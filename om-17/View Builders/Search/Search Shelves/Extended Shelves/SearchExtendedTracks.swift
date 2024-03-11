//
//  SearchExtendedTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct SearchExtendedTracks: View {
    @Environment(PlayerManager.self) var playerManager
    var tracks: [FetchedTrack]?
    var shouldQueueAll: Bool
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 5) {
                if tracks == nil {
                    LoadingBigTracks_component()
                } else {
                    ForEach(Array(tracks!.enumerated()), id: \.offset) { index, track in
                        Button(action: {
                            playerManager.fresh_play(track: track)
                            if (shouldQueueAll) {
                                playerManager.queue_songs(tracks: Array(tracks!.suffix(from: index + 1)))
                            }
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
            .navigationTitle("Songs")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchExtendedTracks(tracks: [FetchedTrack(), FetchedTrack(), FetchedTrack()], shouldQueueAll: false)
        .environment(PlayerManager())
}
