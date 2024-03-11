//
//  TrackDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI

struct SearchTrackLink: View {
    @Environment(PlayerManager.self) var playerManager
    var track: any Track
    var body: some View {
        Button(action: {
            playerManager.fresh_play(track: track)
        }) {
            SearchTrackLink_component(track: track)
        }
            .buttonStyle(.plain)
            .contextMenu {
                TrackMenu(track: track)
            } preview: {
                TrackMenuPreview_component(track: track)
            }
    }
}

#Preview {
    SearchTrackLink(track: FetchedTrack(default: true))
        .environment(PlayerManager())
}


#Preview {
    ScrollView(.horizontal) {
        HStack {
            SearchTrackLink(track: FetchedTrack(default: true))
            SearchTrackLink(track: FetchedTrack(default: true))
            SearchTrackLink(track: FetchedTrack(default: true))
        }
    }
        .environment(PlayerManager())
}


