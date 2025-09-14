//
//  PlaylistTracksNaiveFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

// Function to fetch playlist tracks naive data
func fetchPlaylistTracksNaiveData(playlistID: String, type: Platform) async throws -> FetchedPlaylistInfoTracks {
    return try await NetworkManager.shared.fetch(endpoint: .playlisttracks(platform: type.rawValue, id: playlistID), type: FetchedPlaylistInfoTracks.self)
}

// Actor to manage playlist tracks data
actor PlaylistTracksNaiveViewActor {
    private var fetchedPlaylistInfoTracks: FetchedPlaylistInfoTracks? = nil
    
    func runSearch(playlistID: String, platform: Platform) async throws {
        let tracks = try await fetchPlaylistTracksNaiveData(playlistID: playlistID, type: platform)
        self.fetchedPlaylistInfoTracks = tracks
    }
    
    func getFetchedPlaylistInfoTracks() -> FetchedPlaylistInfoTracks? {
        return fetchedPlaylistInfoTracks
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class PlaylistTracksNaiveViewModel {
    private let viewActor = PlaylistTracksNaiveViewActor()
    
    var fetchedPlaylistInfoTracks: FetchedPlaylistInfoTracks? = nil
    
    func runSearch(playlistID: String, platform: Platform) {
        Task {
            do {
                try await viewActor.runSearch(playlistID: playlistID, platform: platform)
                
                let tracks = await viewActor.getFetchedPlaylistInfoTracks()
                
                await MainActor.run {
                    self.fetchedPlaylistInfoTracks = tracks
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
