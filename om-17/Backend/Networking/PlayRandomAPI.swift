//
//  PlayRandomAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-19.
//

import SwiftUI

func playRandomSongs() async throws -> RandomTracks {
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.random)
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    return try NetworkManager.shared.networkService.decodeRandomTracks(data)
}


struct RandomTracks: Codable {
    var Tracks: [FetchedTrack]
}
