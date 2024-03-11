//
//  LibrarySong.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-07.
//

import SwiftUI

struct LibrarySongLink: View {
    @Environment(PlayerManager.self) var playerManager
    var track: StoredTrack
    var songList: [StoredTrack]
    var index: Int
    var body: some View {
        Group {
            Button(action: {
                let nextTracks: [StoredTrack] = Array(songList.suffix(from: index))
                playerManager.fresh_play_multiple(tracks: nextTracks)
            }) {
                TrackLink_component(track: track)
            }
                .buttonStyle(.plain)
                .contextMenu {
                    TrackMenu(track: track)
                } preview: {
                    TrackMenuPreview_component(track: track)
                }
        }
    }
}

