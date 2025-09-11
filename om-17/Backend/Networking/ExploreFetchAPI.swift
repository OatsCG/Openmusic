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
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(ExploreResults.self, from: data)
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
        self.exploreResults = results
    }
    
    func getExploreResults() -> ExploreResults? {
        return exploreResults
    }
    
    func getIsSearching() -> Bool {
        return isSearching
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
                        self.exploreResults = results
                        self.isSearching = searching
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
    func refresh() async {
        do {
            try await viewActor.runSearch()
            
            let results = await viewActor.getExploreResults()
            let searching = await viewActor.getIsSearching()
            
            await MainActor.run {
                withAnimation {
                    self.exploreResults = results
                    self.isSearching = searching
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
