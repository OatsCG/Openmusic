//
//  PlaybackFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//


import Foundation

func fetchPlaybackData(playbackID: String) async throws -> FetchedPlayback {
    try await NetworkManager.shared.fetch(endpoint: .playback(id: playbackID), type: FetchedPlayback.self)
}
