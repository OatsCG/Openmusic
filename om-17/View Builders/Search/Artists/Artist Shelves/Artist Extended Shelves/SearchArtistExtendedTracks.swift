//
//  SearchArtistExtendedTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

struct SearchArtistExtendedTracks: View {
    @Environment(PlayerManager.self) var playerManager
    var tracks: [any Track]?
    var artistName: String
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 5) {
                if tracks == nil {
                    LoadingBigTracks_component()
                } else {
                    ForEach(Array(tracks!.enumerated()), id: \.offset) { index, track in
                        Button(action: {
                            playerManager.fresh_play(track: track)
                            playerManager.queue_songs(tracks: Array(tracks!.suffix(from: index + 1)))
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
                .safeAreaPadding()
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Songs by \(artistName)")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchArtistExtendedTracks(tracks: [FetchedTrack(), FetchedTrack(), FetchedTrack()], artistName: "Kid Cudi")
        .environment(PlayerManager())
}
