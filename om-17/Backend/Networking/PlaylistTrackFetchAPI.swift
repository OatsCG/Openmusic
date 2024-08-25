//
//  PlaylistTrackFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-02.
//

import SwiftUI

func fetchPlaylistTracksFetchData(importData: ImportData, completion: @escaping @Sendable (Result<ImportedTracks, Error>) -> Void) {
    let title = importData.from.title?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let album = importData.from.album?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let artist = importData.from.artist?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let url = "\(globalIPAddress())/exact?song=\(title)&album=\(album)&artist=\(artist)"
    guard let url = URL(string: url) else {
        print("Invalid URL.")
        return
    }
    
    //async let (data, _) = URLSession.shared.data(from: url)
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode(ImportedTracks.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}
