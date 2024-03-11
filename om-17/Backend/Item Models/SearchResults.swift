//
//  TrackCodable.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI

struct SearchResults: Codable, Hashable {
    var Tracks: [FetchedTrack] = []
    var Albums: [SearchedAlbum] = []
    var Singles: [SearchedAlbum] = []
    var Artists: [SearchedArtist] = []
}

