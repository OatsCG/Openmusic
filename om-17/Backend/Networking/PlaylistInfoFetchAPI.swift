//
//  PlaylistInfoFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

// Function to fetch playlist info data
func fetchPlaylistInfoData(playlistID: String, type: Platform) async throws -> FetchedPlaylistInfo {
    let urlString = "\(globalIPAddress())/playlistinfo?platform=\(type.rawValue)&id=\(playlistID)"
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(FetchedPlaylistInfo.self, from: data)
}

// Actor to manage playlist info data
actor PlaylistInfoViewActor {
    private var fetchedPlaylistInfo: FetchedPlaylistInfo? = nil
    
    func runSearch(playlistID: String, type: Platform) async throws {
        let playlistInfo = try await fetchPlaylistInfoData(playlistID: playlistID, type: type)
        self.fetchedPlaylistInfo = playlistInfo
    }
    
    func getFetchedPlaylistInfo() -> FetchedPlaylistInfo? {
        return fetchedPlaylistInfo
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class PlaylistInfoViewModel {
    private let viewActor = PlaylistInfoViewActor()
    
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
                try await viewActor.runSearch(playlistID: naivePlaylistInfo.id, type: naivePlaylistInfo.platform)
                
                let playlistInfo = await viewActor.getFetchedPlaylistInfo()
                
                await MainActor.run {
                    self.fetchedPlaylistInfo = playlistInfo
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
