//
//  PlaybackModesIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct PlaybackModesIcon: View {
    var track: any Track
    @State private var selectedExplicit: Bool = true
    @Environment(DownloadManager.self) var downloadManager
    var body: some View {
        Button(action: {
            if (selectedExplicit == false && track.Playback_Explicit != nil) {
                selectedExplicit = true
            } else if (selectedExplicit == true && track.Playback_Clean != nil) {
                selectedExplicit = false
            }
        }) {
            //LiveDownloadStatus(download: download)
            PlaybackExplicityDownloadedIcon(track: track, explicit: selectedExplicit)
        }
        .tint(.primary)
        .task {
            if (track.Playback_Clean == nil) {
                selectedExplicit = true
            }
            if (track.Playback_Explicit == nil) {
                selectedExplicit = false
            }
            if (track.Playback_Clean != nil && track.Playback_Explicit != nil) {
                // Favours explicit if both available
                selectedExplicit = true
            }
        }
    }
}

#Preview {
    PlaybackModesIcon(track: FetchedTrack())
}




