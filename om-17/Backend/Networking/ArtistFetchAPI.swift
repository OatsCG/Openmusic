//
//  ArtistFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI

func fetchArtistData(ArtistID: String, completion: @escaping @Sendable (Result<FetchedArtist, Error>) -> Void) {
    let url = "\(globalIPAddress())/artist?id=\(ArtistID)"
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
                let fetchedData = try decoder.decode(FetchedArtist.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable final class ArtistViewModel: Sendable {
    var fetchedArtist: FetchedArtist? = nil
    func runSearch(artistID: String) {
        fetchArtistData(ArtistID: artistID) { (result) in
            switch result {
            case .success(let data):
                withAnimation {
                    self.fetchedArtist = data
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
