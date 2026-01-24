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
    
    return try await NetworkManager.shared.fetch(endpoint: .exact(song: title, album: album, artist: artist), type: ImportedTracks.self)
}
