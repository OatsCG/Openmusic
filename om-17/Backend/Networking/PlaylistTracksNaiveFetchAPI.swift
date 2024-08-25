//
//  PlaylistTracksNaiveFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

func fetchPlaylistTracksNaiveData(playlistID: String, type: Platform, completion: @escaping @Sendable (Result<FetchedPlaylistInfoTracks, Error>) -> Void) {
    let url = "\(globalIPAddress())/playlisttracks?platform=\(type.rawValue)&id=\(playlistID)"
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
                let fetchedData = try decoder.decode(FetchedPlaylistInfoTracks.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable final class PlaylistTracksNaiveViewModel: Sendable {
    var fetchedPlaylistInfoTracks: FetchedPlaylistInfoTracks? = nil
    func runSearch(playlistID: String, platform: Platform) {
        fetchedPlaylistInfoTracks = nil
        fetchPlaylistTracksNaiveData(playlistID: playlistID, type: platform) { (result) in
            switch result {
            case .success(let data):
                //main.async
                self.fetchedPlaylistInfoTracks = data
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
