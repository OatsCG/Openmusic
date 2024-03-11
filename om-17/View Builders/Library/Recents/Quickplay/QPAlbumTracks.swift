//
//  QPAlbumTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-01.
//

import SwiftUI

struct QPAlbumTracks: View {
    @Environment(PlayerManager.self) var playerManager
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let sortedTracks: [any Track] = sort_by_date(tracks: tracks)
            let threeRecentTracks: [any Track] = max_three(tracks: sortedTracks)
            ForEach(Array(threeRecentTracks.enumerated()), id: \.offset) {index, track in
                Button(action: {
                    playerManager.fresh_play_multiple(tracks: Array(sortedTracks.suffix(from: index)))
                    //PlayerManager.shared.fresh_play(track: track)
                }) {
                    HStack {
                        Text(track.Title)
                            .customFont(.subheadline)
                            //.font(Font.custom("Poppins-Regular", size: 15))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                    .contextMenu {
                        TrackMenu(track: track)
                    } preview: {
                        TrackMenuPreview_component(track: track)
                    }
                if (index < tracks.count) {
                    Divider()
                        .opacity(0.8)
                }
            }
        }
    }
    private func sort_by_date(tracks: [any Track]) -> [any Track] {
        if tracks[0] is StoredTrack {
            return tracks.map{($0 as? StoredTrack)!}.sorted{(Int($0.dateAdded.timeIntervalSince1970) - $0.Index) > (Int($1.dateAdded.timeIntervalSince1970) - $1.Index)}
        }
        return tracks
    }

    private func max_three(tracks: [any Track]) -> [any Track] {
        return Array(tracks.prefix(3))
    }
}





