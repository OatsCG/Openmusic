//
//  AlbumFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

func fetchAlbumData(albumID: String) async throws -> FetchedAlbum {
    let url = "\(globalIPAddress())/album?id=\(albumID)"
    guard let url = URL(string: url) else {
        throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(FetchedAlbum.self, from: data)
}


actor AlbumViewActor {
    private var fetchedAlbum: FetchedAlbum? = nil
    private var isSearching: Bool = false
    
    func runSearch(albumID: String) async throws {
        guard !isSearching else { return }
        isSearching = true
        
        defer { isSearching = false }
        
        let album = try await fetchAlbumData(albumID: albumID)
        self.fetchedAlbum = album
    }
    
    func getFetchedAlbum() -> FetchedAlbum? {
        return fetchedAlbum
    }
    func getIsSearching() -> Bool {
        return isSearching
    }
}


@MainActor
@Observable class AlbumViewModel {
    private let viewActor = AlbumViewActor()
    
    var fetchedAlbum: FetchedAlbum? = nil
    
    func runSearch(albumID: String) {
        Task {
            do {
                try await viewActor.runSearch(albumID: albumID)
                
                let album = await viewActor.getFetchedAlbum()
                await MainActor.run {
                    withAnimation {
                        self.fetchedAlbum = album
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
