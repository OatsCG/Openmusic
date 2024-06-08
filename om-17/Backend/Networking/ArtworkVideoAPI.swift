//
//  ArtworkVideoAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-28.
//

import SwiftUI

func fetchAlbumVideoData(albumID: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard (UserDefaults.standard.bool(forKey: "artworkVideoAnimations") == true) else {
        return
    }
    let url = "\(globalIPAddress())/ampVideo?id=\(albumID)"
    guard let url = URL(string: url) else {
        print("Invalid URL.")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode(String.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable class AlbumVideoViewModel {
    var fetchedAlbumVideo: URL? = nil
    var currentSessionID: UUID = UUID()
    func runSearch(albumID: String) {
        let thisSessionID: UUID = UUID()
        self.currentSessionID = thisSessionID
        withAnimation {
            self.fetchedAlbumVideo = nil
        }
        print("starting search with \(albumID)")
        fetchAlbumVideoData(albumID: albumID) { (result) in
            switch result {
            case .success(let data):
                print("success")
                if (thisSessionID != self.currentSessionID) {
                    print("aborted")
                    return
                }
                let attemptedURL: URL? = URL(string: data)
                if let attemptedURL = attemptedURL {
                    if (thisSessionID != self.currentSessionID) {
                        return
                    }
                    DispatchQueue.main.async {
                        withAnimation(.linear(duration: 1).delay(2)) {
                            self.fetchedAlbumVideo = attemptedURL
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
