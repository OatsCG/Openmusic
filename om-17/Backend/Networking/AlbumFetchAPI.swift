//
//  AlbumFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

func fetchAlbumData(AlbumID: String, completion: @escaping (Result<FetchedAlbum, Error>) -> Void) {
    let url = "\(globalIPAddress())/album?id=\(AlbumID)"
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
                let fetchedData = try decoder.decode(FetchedAlbum.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable class AlbumViewModel {
    var fetchedAlbum: FetchedAlbum? = nil
    var isSearching: Bool = false
    func runSearch(albumID: String) {
        if isSearching {
            return
        }
        self.isSearching = true
        
        fetchAlbumData(AlbumID: albumID) { (result) in
            switch result {
            case .success(let data):
                self.isSearching = false
                withAnimation {
                    self.fetchedAlbum = data
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
