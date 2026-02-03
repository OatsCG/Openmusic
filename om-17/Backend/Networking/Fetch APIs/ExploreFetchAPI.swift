//
//  ExploreFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

// Function to fetch explore results
func fetchExploreResults(_ type: ExploreType = .none, page: Int = 0) async throws -> ExploreResults {
    if type == .none {
        if NetworkManager.shared.networkService.supportedFeatures.contains(.isolatedExploreShelfFetch) {
            let shelfEndpoints: [ExploreShelfEndpoint] = [
                ExploreShelfEndpoint(endpoint: .explore(type: "frequent", page: 0), title: "Frequent"),
                ExploreShelfEndpoint(endpoint: .explore(type: "newest", page: 0), title: "Newest"),
                ExploreShelfEndpoint(endpoint: .explore(type: "highest", page: 0), title: "Popular"),
                ExploreShelfEndpoint(endpoint: .explore(type: "random", page: 0), title: "Random"),
            ]
            
            var shelves: [ExploreShelf] = []
            for shelfEndpoint in shelfEndpoints {
                let urlString = NetworkManager.shared.networkService.getEndpointURL(shelfEndpoint.endpoint)
                let logID: UUID = NetworkManager.shared.addNetworkLog(url: urlString, endpoint: shelfEndpoint.endpoint)
                var successData: (any Codable)? = nil
                defer {
                    NetworkManager.shared.updateLogStatus(id: logID, with: successData)
                }
                
                guard let url = URL(string: urlString) else {
                    throw URLError(.badURL)
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                successData = String(data: data, encoding: .utf8)
                let decoded: ExploreShelf = try NetworkManager.shared.networkService.decodeExploreShelf(data, title: shelfEndpoint.title)
                shelves.append(decoded)
            }
            
            return ExploreResults(Shelves: shelves)
            
        } else {
            let urlString = NetworkManager.shared.networkService.getEndpointURL(.explore(type: "", page: 0))
            let logID: UUID = NetworkManager.shared.addNetworkLog(url: urlString, endpoint: .explore(type: "", page: 0))
            var successData: (any Codable)? = nil
            defer {
                NetworkManager.shared.updateLogStatus(id: logID, with: successData)
            }
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            successData = String(data: data, encoding: .utf8)
            let decoded: ExploreResults = try NetworkManager.shared.networkService.decodeExploreResults(data)
            return decoded
        }
    } else {
        var exploreType: String = ""
        var exploreTitle: String = "Albums"
        switch type {
        case .albums:
            exploreType = "alphabeticalByName"
        case .date:
            exploreType = "newest"
        case .none:
            exploreType = ""
        }
        
        let urlString = NetworkManager.shared.networkService.getEndpointURL(.explore(type: exploreType, page: page))
        let logID: UUID = NetworkManager.shared.addNetworkLog(url: urlString, endpoint: .explore(type: exploreType, page: page))
        var successData: (any Codable)? = nil
        defer {
            NetworkManager.shared.updateLogStatus(id: logID, with: successData)
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        successData = String(data: data, encoding: .utf8)
        let decoded: ExploreShelf = try NetworkManager.shared.networkService.decodeExploreShelf(data, title: exploreTitle)
        return ExploreResults(Shelves: [decoded])
    }
}

struct ExploreShelfEndpoint {
    var endpoint: Endpoint
    var title: String
}

// Actor to manage explore data
actor ExploreViewActor {
    private var exploreResults: ExploreResults? = nil
    private var isSearching: Bool = false
    
    func runSearch(_ type: ExploreType, _ currentPage: Int) async throws {
        guard !isSearching else { return }
        isSearching = true
        
        defer { isSearching = false }
        
        let results = try await fetchExploreResults(type, page: currentPage)
        exploreResults = results
    }
    
    func getExploreResults() -> ExploreResults? {
        exploreResults
    }
    
    func getIsSearching() -> Bool {
        isSearching
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class ExploreViewModel {
    private let viewActor = ExploreViewActor()
    var exploreResults: ExploreResults? = nil
    var isSearching: Bool = false
    var isAppending: Bool = false
    
    var currentType: ExploreType = .none
    var currentPage: Int = 0
    var fetchedPages: [Int] = []
    
    func runSearch(_ type: ExploreType) {
        isSearching = true
        currentType = type
        currentPage = 0
        fetchedPages = []
        Task {
            do {
                try await viewActor.runSearch(currentType, currentPage)
                
                let results = await viewActor.getExploreResults()
                let searching = await viewActor.getIsSearching()
                
                await MainActor.run {
                    withAnimation {
                        exploreResults = results
                        isSearching = searching
                        if type != .none {
                            fetchedPages.append(0)
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        isSearching = false
                    }
                }
            }
        }
    }
    
    func requestNextPage() {
        guard !isSearching else { return }
        guard !isAppending else { return }
        let wantsPage: Int = !fetchedPages.contains(currentPage) ? currentPage : currentPage + 1
        guard !fetchedPages.contains(wantsPage) else { return }
        isAppending = true
        Task {
            do {
                try await viewActor.runSearch(currentType, wantsPage)
                let results = await viewActor.getExploreResults()
                let searching = await viewActor.getIsSearching()
                await MainActor.run {
                    withAnimation {
                        if let index = exploreResults?.Shelves.indices.first {
                            exploreResults?.Shelves[index].Albums.append(contentsOf: results?.Shelves.first?.Albums ?? [])
                            currentPage = wantsPage
                            fetchedPages.append(wantsPage)
                        }
                        isSearching = searching
                        isAppending = false
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        isSearching = false
                        isAppending = false
                    }
                }
                print("Error: \(error)")
            }
        }
    }
}

struct ExploreResults: Codable, Hashable {
    var Shelves: [ExploreShelf]
    
    private enum CodingKeys: String, CodingKey {
        case Shelves
    }
}

struct ExploreCabinet: Codable, Hashable {
    var Shelves: [ExploreShelf]
    
    private enum CodingKeys: String, CodingKey {
        case Shelves
    }
}

struct ExploreShelf: Codable, Hashable {
    var Title: String
    var Albums: [SearchedAlbum]
    
    private enum CodingKeys: String, CodingKey {
        case Title, Albums
    }
}
