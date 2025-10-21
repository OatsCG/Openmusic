//
//  TracklistDL.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-13.
//

import SwiftUI
import SwiftData

struct LibraryAlbumTracklist: View {
    var tracks: [any Track]
    
    var body: some View {
        ForEach(Array(tracks.enumerated()), id: \.offset) {index, track in
            SearchAlbumSongLink(track: track, continuation: Array(tracks.suffix(from: index)))
            Divider()
        }
    }
}
