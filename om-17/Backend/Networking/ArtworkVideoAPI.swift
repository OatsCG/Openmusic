//
//  ArtworkVideoAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-28.
//

import SwiftUI

// Function to fetch album video data
func fetchAlbumVideoData(albumID: String) async throws -> String {
    // Check if artwork video animations are enabled
    guard UserDefaults.standard.bool(forKey: "artworkVideoAnimations") == true else {
        throw NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Artwork video animations are disabled."])
    }
    
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.ampVideo(id: albumID))
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(String.self, from: data)
}

// Actor to manage album video data
actor AlbumVideoViewActor {
    private var fetchedAlbumVideo: URL? = nil
    private var currentSessionID: UUID = UUID()
    
    func runSearch(albumID: String) async throws {
        let thisSessionID = UUID()
        self.currentSessionID = thisSessionID
        self.fetchedAlbumVideo = nil
        
        let videoData = try await fetchAlbumVideoData(albumID: albumID)
        
        guard thisSessionID == self.currentSessionID else {
            print("Search aborted")
            return
        }
        
        if let url = URL(string: videoData), thisSessionID == self.currentSessionID {
            self.fetchedAlbumVideo = url
        }
    }
    
    func getFetchedAlbumVideo() -> URL? {
        return fetchedAlbumVideo
    }
    
    func getCurrentSessionID() -> UUID {
        return currentSessionID
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class AlbumVideoViewModel {
    private let viewActor = AlbumVideoViewActor()
    
    var fetchedAlbumVideo: URL? = nil
    var vAlbumID: String = ""
    var currentSessionID: UUID = UUID()
    
    func runSearch(albumID: String) {
        Task {
            do {
                try await viewActor.runSearch(albumID: albumID)
                
                let albumVideo = await viewActor.getFetchedAlbumVideo()
                let sessionID = await viewActor.getCurrentSessionID()
                
                await MainActor.run {
                    withAnimation(.linear(duration: 1).delay(2)) {
                        self.fetchedAlbumVideo = albumVideo
                        self.vAlbumID = albumID
                        self.currentSessionID = sessionID
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
