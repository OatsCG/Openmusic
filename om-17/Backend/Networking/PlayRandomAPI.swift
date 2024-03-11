//
//  PlayRandomAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-19.
//

import SwiftUI

func playRandomSongs(completion: @escaping (Result<RandomTracks, Error>) -> Void) {
    let url = "\(globalIPAddress())/random"
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
                let fetchedData = try decoder.decode(RandomTracks.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

struct RandomTracks: Codable {
    var Tracks: [FetchedTrack]
}
