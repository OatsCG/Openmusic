//
//  PlaybackFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//


import Foundation

func fetchPlaybackData(playbackID: String) async throws -> FetchedPlayback {
    let urlString = "\(globalIPAddress())/playback?id=\(playbackID)"
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(FetchedPlayback.self, from: data)
}
