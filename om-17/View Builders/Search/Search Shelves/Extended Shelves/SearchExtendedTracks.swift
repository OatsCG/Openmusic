//
//  SearchExtendedTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct SearchExtendedTracks: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var tracks: [FetchedTrack]?
    var shouldQueueAll: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 5) {
                if let tracks {
                    ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                        Button(action: {
                            playerManager.fresh_play(track: track)
                            if shouldQueueAll {
                                playerManager.queue_songs(tracks: Array(tracks.suffix(from: index + 1)))
                            }
                        }) {
                            TrackLink_component(track: track)
                        }
                            .buttonStyle(.plain)
                            .contextMenu {
                                TrackMenu(track: track)
                                    .environment(fontManager)
                            } preview: {
                                TrackMenuPreview_component(track: track)
                                    .environment(fontManager)
                            }
                    }
                } else {
                    LoadingBigTracks_component()
                }
            }
                .safeAreaPadding()
                .padding(.top, 1)
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
