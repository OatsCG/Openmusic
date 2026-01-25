//
//  NetworkService.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-23.
//

import Foundation

protocol NetworkService {
    var supportedFeatures: [ServerFeature] { get }
    
    func baseURL() -> String
    func getEndpointURL(_ endpoint: Endpoint) -> String
    
    func decodeServerStatus(_ data: Data) throws -> ServerStatus
    func decodeExploreResults(_ data: Data) throws -> ExploreResults
    func decodeVibeShelf(_ data: Data) throws -> VibeShelf
    func decodeSearchResults(_ data: Data) throws -> SearchResults
    func decodeFetchedTracks(_ data: Data) throws -> FetchedTracks
    func decodeFetchedAlbum(_ data: Data) throws -> FetchedAlbum
    func decodeFetchedArtist(_ data: Data) throws -> FetchedArtist
    func decodeRandomTracks(_ data: Data) throws -> RandomTracks
    func decodeFetchedPlaylistInfo(_ data: Data) throws -> FetchedPlaylistInfo
    func decodeFetchedPlaylistInfoTracks(_ data: Data) throws -> FetchedPlaylistInfoTracks
    func decodeImportedTracks(_ data: Data) throws -> ImportedTracks
    func decodeFetchedPlayback(_ data: Data) throws -> FetchedPlayback
    func decodeSearchedAlbum(_ data: Data) throws -> SearchedAlbum
    func decodeFetchedTrack(_ data: Data) throws -> FetchedTrack
}

enum ServerType: String, Codable {
    case openmusic, navidrome
}

enum Endpoint {
    case status,
        explore,
        vibes,
        search(q: String),
        quick(q: String),
        album(id: String),
        artist(id: String),
        random,
        playlistinfo(platform: String, id: String),
        ampVideo(id: String),
        playlisttracks(platform: String, id: String),
        exact(song: String, album: String, artist: String),
        suggest(songs: String),
        suggestVibe(genre: String, acousticness: Float, danceability: Float, energy: Float, instrumentalness: Float, liveness: Float, mode: Int, speechiness: Float, valence: Float),
        playback(id: String),
        image(id: String, w: Int, h: Int)
}

enum ServerFeature {
    case vibes,
         quicksearch,
         random,
         ampVideo,
         playlistmatching,
         suggestions
}

enum NetworkServiceError: Error {
    case notImplementedError(String), incompleteError
}
