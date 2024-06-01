//
//  StoredArtwork.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-10.
//

import Foundation
import SwiftUI

func BuildArtworkURL(imgID: String?, resolution: Resolution) -> URL? {
    if imgID == nil {
        return nil
//        let url = URL(string: "")
//        return url ?? nil
    } else {
        let url = URL(string: "https://lh3.googleusercontent.com/\(imgID!)=w\(resolution.rawValue)-h\(resolution.rawValue)-l90-rj")
        return url ?? nil
    }
}

func downloadAlbumArt(ArtworkID: String, completion: @escaping (URL?) -> Void) {
    let downloadURL: String = "https://lh3.googleusercontent.com/\(ArtworkID)=w\(1080)-h\(1080)-l90-rj"
    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Artwork-\(ArtworkID).jpg")
    if let destinationURL = destinationURL {
        if FileManager().fileExists(atPath: destinationURL.path) {
            completion(destinationURL)
            return
        } else {
            let urlRequest = URLRequest(url: URL(string: downloadURL)!)
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
                        completion(destinationURL)
                    } catch _ {
                        return
                    }
                }
            }
            dataTask.resume()
        }
    }
}

func downloadPlaylistArt(playlistID: UUID, ArtworkURL: String) async {
    let downloadURL: URL? = URL(string: ArtworkURL)
    if downloadURL == nil {
        return
    }
    
    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg")
    if let destinationURL = destinationURL {
        if FileManager().fileExists(atPath: destinationURL.path) {
        } else {
            let urlRequest = URLRequest(url: downloadURL!)
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
    if let ArtworkID = ArtworkID {
        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Artwork-\(ArtworkID).jpg")
        if FileManager().fileExists(atPath: destination!.path) {
            return true
        }
        return false
    } else {
        return false
    }
}

func RetrieveArtwork(ArtworkID: String) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent("Artwork-\(ArtworkID).jpg")
    return(destinationUrl!)
}

func RetrieveArtwork(url: String) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent(url)
    return(destinationUrl!)
}

func PlaylistArtworkExists(playlistID: UUID) -> Bool {
    let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg")
    if FileManager().fileExists(atPath: destination!.path) {
        return(true)
    }
    return(false)
}

func RetrievePlaylistArtwork(playlistID: UUID) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent("Playlist-\(playlistID.uuidString).jpg")
    return(destinationUrl!)
}


