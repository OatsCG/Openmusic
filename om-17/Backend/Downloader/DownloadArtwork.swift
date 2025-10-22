//
//  StoredArtwork.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-10.
//

import Foundation
import SwiftUI

func isImageURL(_ url: URL?) async throws -> Bool {
    guard let url = url else { return false }
    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"

    let (_, response) = try await URLSession.shared.data(for: request)
    
    let httpResponse = response as? HTTPURLResponse
    if let contentType = httpResponse?.value(forHTTPHeaderField: "Content-Type") {
        return contentType.lowercased().hasPrefix("image/")
    }
    
    return false
}

func BuildArtworkURL(imgID: String?, resolution: Resolution) -> URL? {
    guard let imgID = imgID else { return nil }
    
//    if await (try? isImageURL(URL(string: imgID))) ?? false {
//        return URL(string: imgID)
//    }
    
    let url = URL(string: NetworkManager.shared.networkService.getEndpointURL(.image(id: imgID, w: resolution.rawValue, h: resolution.rawValue)))
    return url ?? nil
}

func downloadAlbumArt(artworkID: String) async -> URL? {
    let downloadURLString = "https://lh3.googleusercontent.com/\(artworkID)=w\(1080)-h\(1080)-l90-rj"
    
    guard let downloadURL = URL(string: downloadURLString),
          let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Artwork-\(artworkID).jpg") else {
        return nil
    }
    
    // Check if the file already exists
    if FileManager.default.fileExists(atPath: destinationURL.path) {
        return destinationURL
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(from: downloadURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        try data.write(to: destinationURL, options: .atomic)
        return destinationURL
    } catch {
        return nil
    }
}

func downloadPlaylistArt(playlistID: UUID, ArtworkURL: String) {
    guard let downloadURL = URL(string: ArtworkURL) else { return }
    
    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg")
    if let destinationURL {
        if FileManager.default.fileExists(atPath: destinationURL.path) {
        } else {
            let urlRequest = URLRequest(url: downloadURL)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    return
                }
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    //main.async
                    do {
                        try data.write(to: destinationURL, options: Data.WritingOptions.atomic)
                    } catch _ {
                        return
                    }
                }
            }
            dataTask.resume()
        }
    }
}

func ArtworkExists(ArtworkID: String?) -> Bool {
    if let ArtworkID,
       let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Artwork-\(ArtworkID).jpg").path,
       FileManager.default.fileExists(atPath: path) {
        return true
    }
    return false
}

func RetrieveArtwork(ArtworkID: String) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent("Artwork-\(ArtworkID).jpg")
    return destinationUrl ?? URL(string: "")!
}

func RetrieveArtwork(url: String) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent(url)
    return destinationUrl ?? URL(string: "")!
}

func PlaylistArtworkExists(playlistID: UUID) -> Bool {
    if let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg"),
       FileManager.default.fileExists(atPath: destination.path) {
        return true
    }
    return false
}

func RetrievePlaylistArtwork(playlistID: UUID) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg")
    return destinationUrl ?? URL(string: "")!
}
