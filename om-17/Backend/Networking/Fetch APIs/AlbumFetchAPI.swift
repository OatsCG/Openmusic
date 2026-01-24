//
//  AlbumFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

func fetchAlbumData(albumID: String) async throws -> FetchedAlbum {
    try await NetworkManager.shared.fetch(endpoint: .album(id: albumID), type: FetchedAlbum.self)
}

actor AlbumViewActor {
    private var fetchedAlbum: FetchedAlbum? = nil
    private var isSearching: Bool = false
    
    func runSearch(albumID: String) async throws {
        guard !isSearching else { return }
        isSearching = true
        
        defer { isSearching = false }
        
        let album = try await fetchAlbumData(albumID: albumID)
        fetchedAlbum = album
    }
    
    func getFetchedAlbum() -> FetchedAlbum? {
        fetchedAlbum
    }
    func getIsSearching() -> Bool {
        isSearching
    }
}

@MainActor
@Observable class AlbumViewModel {
    private let viewActor = AlbumViewActor()
    
    var fetchedAlbum: FetchedAlbum? = nil
    var areTracksStored: Bool? = nil
    
    func runSearch(albumID: String, database: BackgroundDatabase?) {
        Task {
            do {
                try await viewActor.runSearch(albumID: albumID)
                
                let album = await viewActor.getFetchedAlbum()
                var isstored: Bool? = nil
                if let album = album {
                    isstored = await database?.are_tracks_stored(tracks: album.Tracks)
                }
                await MainActor.run {
                    withAnimation {
                        fetchedAlbum = album
                        areTracksStored = isstored
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
