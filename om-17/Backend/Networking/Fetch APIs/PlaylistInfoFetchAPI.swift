//
//  PlaylistInfoFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

// Function to fetch playlist info data
func fetchPlaylistInfoData(playlistID: String, type: Platform) async throws -> FetchedPlaylistInfo {
    try await NetworkManager.shared.fetch(endpoint: .playlistinfo(platform: type.rawValue, id: playlistID), type: FetchedPlaylistInfo.self)
}

// Actor to manage playlist info data
actor PlaylistInfoViewActor {
    private var fetchedPlaylistInfo: FetchedPlaylistInfo? = nil
    var fetchID = UUID()
    
    func runSearch(playlistID: String, type: Platform) async throws {
        let thisFetchID: UUID = UUID()
        fetchID = thisFetchID
        let playlistInfo = try await fetchPlaylistInfoData(playlistID: playlistID, type: type)
        if fetchID == thisFetchID {
            fetchedPlaylistInfo = playlistInfo
        }
    }
    
    func getFetchedPlaylistInfo() -> FetchedPlaylistInfo? {
        fetchedPlaylistInfo
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class PlaylistInfoViewModel {
    private let viewActor = PlaylistInfoViewActor()
    
    var isFetching: Bool = false
    var fetchedPlaylistInfo: FetchedPlaylistInfo? = nil
    
    func runSearch(playlistURL: String) {
        Task {
            // Recognize the playlist
            let naivePlaylistInfo = recognizePlaylist(url: playlistURL)
            if naivePlaylistInfo.platform == .unknown {
                return
            }
            
            do {
                // Fetch playlist info
                await MainActor.run {
                    isFetching = true
                }
                try await viewActor.runSearch(playlistID: naivePlaylistInfo.id, type: naivePlaylistInfo.platform)
                
                let playlistInfo = await viewActor.getFetchedPlaylistInfo()
                
                await MainActor.run {
                    isFetching = false
                    withAnimation {
                        fetchedPlaylistInfo = playlistInfo
                    }
                }
            } catch {
                await MainActor.run {
                    isFetching = false
                }
                print("Error: \(error)")
            }
        }
    }
}
