//
//  PlayRandomAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-19.
//

import SwiftUI

func playRandomSongs() async throws -> RandomTracks {
    return try await NetworkManager.shared.fetch(endpoint: .random, type: RandomTracks.self)
}


struct RandomTracks: Codable {
    var Tracks: [FetchedTrack]
}
