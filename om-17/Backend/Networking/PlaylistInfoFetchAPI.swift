//
//  PlaylistInfoFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

func fetchPlaylistInfoData(playlistID: String, type: Platform, completion: @escaping @Sendable (Result<FetchedPlaylistInfo, Error>) -> Void) {
    let url = "\(globalIPAddress())/playlistinfo?platform=\(type.rawValue)&id=\(playlistID)"
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
                let fetchedData = try decoder.decode(FetchedPlaylistInfo.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable final class PlaylistInfoViewModel: Sendable {
    var fetchedPlaylistInfo: FetchedPlaylistInfo? = nil
    func runSearch(playlistURL: String) {
        fetchedPlaylistInfo = nil
        let naivePlaylistInfo = recognizePlaylist(url: playlistURL)
        if (naivePlaylistInfo.platform == .unknown) {
            return
        }
        fetchPlaylistInfoData(playlistID: naivePlaylistInfo.id, type: naivePlaylistInfo.platform) { (result) in
            switch result {
            case .success(let data):
                //main.async
                self.fetchedPlaylistInfo = data
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
