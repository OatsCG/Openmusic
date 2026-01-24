//
//  VibesFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-21.
//

import SwiftUI

// Function to fetch explore results
func fetchVibeResults() async throws -> VibeShelf {
    try await NetworkManager.shared.fetch(endpoint: .vibes, type: VibeShelf.self)
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
        vibeResults = results
    }
    
    func getVibeResults() -> VibeShelf? {
        vibeResults
    }
    
    func getIsSearching() -> Bool {
        isSearching
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
                try await viewActor.runSearch()
                let results = await viewActor.getVibeResults()
                let searching = await viewActor.getIsSearching()
                
                await MainActor.run {
                    withAnimation {
                        vibeResults = results
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
            
            let results = await viewActor.getVibeResults()
            let searching = await viewActor.getIsSearching()
            
            await MainActor.run {
                withAnimation {
                    vibeResults = results
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


struct VibeShelf: Codable, Hashable {
    var vibes: [VibeObject]
    
    private enum CodingKeys: String, CodingKey {
        case vibes
    }
}

struct VibeObject: Codable, Hashable, Identifiable {
    let id = UUID()
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
