//
//  ArtistFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI

// Function to fetch artist data
func fetchArtistData(artistID: String) async throws -> FetchedArtist {
    let urlString = "\(globalIPAddress())/artist?id=\(artistID)"
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(FetchedArtist.self, from: data)
}

// Actor to manage artist data
actor ArtistViewActor {
    private var fetchedArtist: FetchedArtist? = nil
    
    func runSearch(artistID: String) async throws {
        let artist = try await fetchArtistData(artistID: artistID)
        self.fetchedArtist = artist
    }
    
    func getFetchedArtist() -> FetchedArtist? {
        return fetchedArtist
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class ArtistViewModel {
    private let viewActor = ArtistViewActor()
    
    var fetchedArtist: FetchedArtist? = nil
    
    func runSearch(artistID: String) {
        Task {
            do {
                try await viewActor.runSearch(artistID: artistID)
                
                let artist = await viewActor.getFetchedArtist()
                
                await MainActor.run {
                    withAnimation {
                        self.fetchedArtist = artist
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
