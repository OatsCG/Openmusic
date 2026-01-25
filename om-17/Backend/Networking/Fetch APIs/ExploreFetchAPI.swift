//
//  ExploreFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

// Function to fetch explore results
func fetchExploreResults() async throws -> ExploreResults {
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.explore)
    let logID: UUID = NetworkManager.shared.addNetworkLog(url: urlString, endpoint: .explore)
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

// Actor to manage explore data
actor ExploreViewActor {
    private var exploreResults: ExploreResults? = nil
    private var isSearching: Bool = false
    
    func runSearch() async throws {
        guard !isSearching else { return }
        isSearching = true
        
        defer { isSearching = false }
        
        let results = try await fetchExploreResults()
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
        Task {
            do {
                try await viewActor.runSearch()
                
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
                print("Error: \(error)")
            }
        }
    }
    
    func refresh() async {
        do {
            try await viewActor.runSearch()
            
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
                    self.isSearching = false
                }
            }
            print("Error: \(error)")
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
