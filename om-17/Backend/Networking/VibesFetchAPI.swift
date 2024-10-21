//
//  VibesFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-21.
//

import SwiftUI

// Function to fetch explore results
func fetchVibeResults() async throws -> VibeShelf {
    let urlString = "\(globalIPAddress())/vibes"
    print(urlString)
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(VibeShelf.self, from: data)
}

// Actor to manage explore data
actor VibesViewActor {
    private var vibeResults: VibeShelf? = nil
    private var isSearching: Bool = false
    
    func runSearch() async throws {
        guard !isSearching else { return }
        isSearching = true
        
        defer { isSearching = false }
        
        let results = try await fetchVibeResults()
        self.vibeResults = results
    }
    
    func getVibeResults() -> VibeShelf? {
        return vibeResults
    }
    
    func getIsSearching() -> Bool {
        return isSearching
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class VibesViewModel {
    private let viewActor = VibesViewActor()
    
    var vibeResults: VibeShelf? = nil
    var isSearching: Bool = false
    
    func runSearch() {
        Task {
            do {
                print("fetching...")
                try await viewActor.runSearch()
                print("got!")
                let results = await viewActor.getVibeResults()
                print(results)
                let searching = await viewActor.getIsSearching()
                
                await MainActor.run {
                    withAnimation {
                        self.vibeResults = results
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
            
            let results = await viewActor.getVibeResults()
            let searching = await viewActor.getIsSearching()
            
            await MainActor.run {
                withAnimation {
                    self.vibeResults = results
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


struct VibeShelf: Codable, Hashable {
    var vibes: [VibeObject]
    
    private enum CodingKeys: String, CodingKey {
        case vibes
    }
}

struct VibeObject: Codable, Hashable {
    let title: String
    let genre: String
    let acousticness: Float
    let danceability: Float
    let energy: Float
    let instrumentalness: Float
    let liveness: Float
    let mode: Int
    let speechiness: Float
    let valence: Float
    let hue: Float
    
    private enum CodingKeys: String, CodingKey {
        case title, genre, acousticness, danceability, energy, instrumentalness, liveness, mode, speechiness, valence, hue
    }
}
