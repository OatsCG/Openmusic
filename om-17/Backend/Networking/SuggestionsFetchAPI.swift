//
//  SuggestionsFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

// Function to fetch suggestions data
func fetchSuggestionsData(songs: [NaiveTrack]) async throws -> ImportedTracks {
    let songsAsStrings: [String] = songs.map { song in
        let title = song.title.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let album = song.album.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let artist = song.artists.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        return "\(title)OMSEPSONGCOMPONENT\(album)OMSEPSONGCOMPONENT\(artist)"
    }
    
    let songsJoined = songsAsStrings.joined(separator: "OMSEPNEWSONG")
    
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.suggest(songs: songsJoined))
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    return try NetworkManager.shared.networkService.decodeImportedTracks(data)
}

func fetchSuggestionsData(vibe: VibeObject) async throws -> ImportedTracks {
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.suggestVibe(genre: vibe.genre, acousticness: vibe.acousticness, danceability: vibe.danceability, energy: vibe.energy, instrumentalness: vibe.instrumentalness, liveness: vibe.liveness, mode: vibe.mode, speechiness: vibe.speechiness, valence: vibe.valence))
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(ImportedTracks.self, from: data)
}

// Actor to manage suggestions data fetching
actor FetchSuggestionsActor {
    private var isFetching: Bool = false
    
    func runSearch(songs: [NaiveTrack], playerManager: PlayerManager) async throws {
        guard !isFetching else { return }
        guard !songs.isEmpty else {
            isFetching = false
            return
        }
        
        isFetching = true
        
        defer { isFetching = false }
        
        let data = try await fetchSuggestionsData(songs: songs)
        
        if await playerManager.getEnjoyedSongsNaive(limit: 5) == songs {
            await playerManager.queue_songs(tracks: data.Tracks, wasSuggested: true)
        }
    }
    
    func runSearch(vibe: VibeObject, playerManager: PlayerManager) async throws {
        guard !isFetching else { return }
        
        isFetching = true
        
        defer { isFetching = false }
        
        let data = try await fetchSuggestionsData(vibe: vibe)
        
        await playerManager.queue_songs(tracks: data.Tracks, wasSuggested: true)
    }
    
    func getIsFetching() -> Bool {
        return isFetching
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class FetchSuggestionsModel {
    private let suggestionsActor = FetchSuggestionsActor()
    
    var isFetching: Bool = false
    
    func runSearch(songs: [NaiveTrack], playerManager: PlayerManager) {
        self.isFetching = true
        Task {
            do {
                try await suggestionsActor.runSearch(songs: songs, playerManager: playerManager)
                
                let fetching = await suggestionsActor.getIsFetching()
                
                await MainActor.run {
                    self.isFetching = fetching
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    self.isFetching = false
                }
            }
        }
    }
    
    func runSearch(vibe: VibeObject, playerManager: PlayerManager) {
        self.isFetching = true
        Task {
            do {
                try await suggestionsActor.runSearch(vibe: vibe, playerManager: playerManager)
                
                let fetching = await suggestionsActor.getIsFetching()
                
                await MainActor.run {
                    self.isFetching = fetching
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    self.isFetching = false
                }
            }
        }
    }
}
