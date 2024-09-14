//
//  PlaybackModesIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct PlaybackModesIcon: View {
    @Environment(DownloadManager.self) var downloadManager
    @Environment(OMUser.self) var omUser
    @State private var selectedExplicit: Bool = true
    @State var isLiked: Bool = false
    var track: any Track
    var body: some View {
//        Button(action: {
//            if (selectedExplicit == false && track.Playback_Explicit != nil) {
//                selectedExplicit = true
//            } else if (selectedExplicit == true && track.Playback_Clean != nil) {
//                selectedExplicit = false
//            }
//        }) {
//            //LiveDownloadStatus(download: download)
//            PlaybackExplicityDownloadedIcon(track: track, explicit: selectedExplicit)
//        }
        HStack {
            if (isLiked) {
                Image(systemName: "heart.fill")
                    .symbolRenderingMode(.multicolor)
            } else {
                PlaybackExplicityDownloadedIcon(track: track, explicit: selectedExplicit)
                    .tint(.primary)
            }
        }
            .transition(.blurReplace)
            .task {
                self.initSelectedExplicit()
                if (omUser.isSongLiked(track: track)) {
                    updateIsLikedInstant()
                }
            }
            .onChange(of: omUser.likedSongs) {
                updateIsLiked()
            }
    }
    private func initSelectedExplicit() {
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
    private func updateIsLikedInstant() {
        withAnimation {
            if (omUser.isSongLiked(track: track)) {
                self.isLiked = true
            } else {
                self.isLiked = false
            }
        }
    }
    private func updateIsLiked() {
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { _ in
            DispatchQueue.main.async {
                withAnimation {
                    if (omUser.isSongLiked(track: track)) {
                        self.isLiked = true
                    } else {
                        self.isLiked = false
                    }
                }
            }
        }
    }
}

#Preview {
    PlaybackModesIcon(track: FetchedTrack())
}




