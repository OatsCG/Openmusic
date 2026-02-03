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
                ExploreShelfEndpoint(endpoint: .explore(type: "recent", page: 0), title: "Recently Played", exploreType: .recent),
                ExploreShelfEndpoint(endpoint: .explore(type: "newest", page: 0), title: "Recently Added", exploreType: .newest),
                ExploreShelfEndpoint(endpoint: .explore(type: "frequent", page: 0), title: "Frequently Played", exploreType: .frequent),
                ExploreShelfEndpoint(endpoint: .explore(type: "highest", page: 0), title: "Popular", exploreType: .highest),
                ExploreShelfEndpoint(endpoint: .explore(type: "alphabeticalByName", page: 0), title: "Sorted Alphabetically", exploreType: .alphabeticalByName),
                ExploreShelfEndpoint(endpoint: .explore(type: "alphabeticalByArtist", page: 0), title: "Sorted by Artist", exploreType: .alphabeticalByArtist),
                ExploreShelfEndpoint(endpoint: .explore(type: "random", page: 0), title: "Random", exploreType: .random)
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
                let decoded: ExploreShelf = try NetworkManager.shared.networkService.decodeExploreShelf(data, exploreShelfEndpoint: shelfEndpoint)
                if !decoded.Albums.isEmpty {
                    shelves.append(decoded)
                }
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
        switch type {
        case .random:
            exploreType = "random"
        case .newest:
            exploreType = "newest"
        case .highest:
            exploreType = "highest"
        case .frequent:
            exploreType = "frequent"
        case .recent:
            exploreType = "recent"
        case .alphabeticalByName:
            exploreType = "alphabeticalByName"
        case .alphabeticalByArtist:
            exploreType = "alphabeticalByArtist"
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
        let decoded: ExploreShelf = try NetworkManager.shared.networkService.decodeExploreShelf(data, exploreShelfEndpoint: ExploreShelfEndpoint(endpoint: .explore(type: exploreType, page: page), title: "Albums", exploreType: type))
        return ExploreResults(Shelves: [decoded])
    }
}

struct ExploreShelfEndpoint {
    var endpoint: Endpoint
    var title: String
    var exploreType: ExploreType
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
    
    func runSearch() {
        isSearching = true
        Task {
            do {
                try await viewActor.runSearch(.none, 0)
                let results = await viewActor.getExploreResults()
                let searching = await viewActor.getIsSearching()
                
                await MainActor.run {
                    withAnimation {
                        exploreResults = results
                        isSearching = searching
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
    var type: ExploreType = .none
    
    private enum CodingKeys: String, CodingKey {
        case Title, Albums
    }
}
