//
//  SuggestionsFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

func fetchSuggestionsData(songs: [NaiveTrack], completion: @escaping (Result<ImportedTracks, Error>) -> Void) {
    var songsAsStrings: [String] = []
    for song in songs {
        let title: String = song.title.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let album: String = song.album.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let artist: String = song.artists.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        songsAsStrings.append("\(title)OMSEPSONGCOMPONENT\(album)OMSEPSONGCOMPONENT\(artist)")
    }
    let songsJoined: String = songsAsStrings.joined(separator: "OMSEPNEWSONG")
    
    let url = "\(globalIPAddress())/suggest?songs=\(songsJoined)"
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


@Observable class FetchSuggestionsModel {
    var isFetching: Bool = false
    func runSearch(songs: [NaiveTrack], playerManager: PlayerManager) {
        if (isFetching == true) {
            return
        }
        isFetching = true
        if (songs.count == 0) {
            self.isFetching = false
            return
        }
        fetchSuggestionsData(songs: songs) { (result) in
            switch result {
            case .success(let data):
                if (playerManager.getEnjoyedSongsNaive(limit: 5) == songs) {
                    playerManager.queue_songs(tracks: data.Tracks, wasSuggested: true)
                }
                self.isFetching = false
            case .failure(let error):
                print("Error: \(error)")
                self.isFetching = false
            }
        }
    }
}
