//
//  AlbumTrackRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

// playerManager.currentQueueItem?.Track.TrackID == track.TrackID
func isPlayingTrackID(playerManager: PlayerManager, trackID: String) -> Bool {
    let queueItem: QueueItem? = playerManager.currentQueueItem
    if (queueItem == nil) {
        return false
    } else {
        let queueTrackID: String = queueItem!.Track.TrackID
        if (queueTrackID == trackID) {
            return true
        } else {
            return false
        }
    }
    
}

struct SearchAlbumSongLink: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var continuation: [any Track]?
    var min: Int?
    var max: Int?
    var body: some View {
        Button(action: {
            playerManager.fresh_play_multiple(tracks: continuation ?? [])
            
        }) {
            HStack {
                if (isPlayingTrackID(playerManager: playerManager, trackID: track.TrackID)) {
                    TrackSpeakerIcon()
                } else {
                    Text(String(track.Index))
                        .foregroundColor(.secondary)
                        .font(.callout .bold() .monospaced())
                        .lineLimit(1)
                }
                VStack(alignment: .leading) {
                    Text(track.Title)
                        .foregroundColor(.primary)
                        .customFont(fontManager, .callout)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    Text(secondsToText(seconds: track.Length) + ((track.Features.count > 0) ? (" • " + stringArtists(artistlist: track.Features)) : ""))
                        .foregroundColor(.secondary)
                        .customFont(fontManager, .caption)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                Spacer()
                //popularity icon
                if let ftrack = track as? FetchedTrack {
                    PopularityIcon(views: ftrack.Views, min: min, max: max)
                }
                PlaybackModesIcon(track: track)
            }
                .padding([.top, .bottom], 10)
                .contentShape(Rectangle())
        }
            .buttonStyle(.plain)
            .contextMenu {
                TrackMenu(track: track)
            } preview: {
                TrackMenuPreview_component(track: track)
            }
            .padding(0)
    }
}

#Preview {
    SearchAlbumContent(album: SearchedAlbum())
}
