//
//  PlaybackFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//


import Foundation

func fetchPlaybackData(PlaybackID: String) async throws -> FetchedPlayback {
    let url = "\(globalIPAddress())/playback?id=\(PlaybackID)"
    guard let url = URL(string: url) else {
        throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let fetchedData = try decoder.decode(FetchedPlayback.self, from: data)
    return fetchedData
}
