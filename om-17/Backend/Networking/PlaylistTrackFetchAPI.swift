//
//  PlaylistTrackFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-02.
//

import SwiftUI

func fetchPlaylistTracksFetchData(importData: ImportData) async throws -> ImportedTracks {
    let title = importData.from.title?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let album = importData.from.album?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let artist = importData.from.artist?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.exact(song: title, album: album, artist: artist))
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(ImportedTracks.self, from: data)
}

