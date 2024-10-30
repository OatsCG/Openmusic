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
    var fetchID: UUID = UUID()
    
    func runSearch(playlistID: String, type: Platform) async throws {
        let thisFetchID: UUID = UUID()
        self.fetchID = thisFetchID
        let playlistInfo = try await fetchPlaylistInfoData(playlistID: playlistID, type: type)
        if self.fetchID == thisFetchID {
            self.fetchedPlaylistInfo = playlistInfo
        }
    }
    
    func getFetchedPlaylistInfo() -> FetchedPlaylistInfo? {
        return fetchedPlaylistInfo
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
                    self.isFetching = true
                }
                try await viewActor.runSearch(playlistID: naivePlaylistInfo.id, type: naivePlaylistInfo.platform)
                
                let playlistInfo = await viewActor.getFetchedPlaylistInfo()
                
                await MainActor.run {
                    self.isFetching = false
                    withAnimation {
                        self.fetchedPlaylistInfo = playlistInfo
                    }
                }
            } catch {
                await MainActor.run {
                    self.isFetching = false
                }
                print("Error: \(error)")
            }
        }
    }
}
