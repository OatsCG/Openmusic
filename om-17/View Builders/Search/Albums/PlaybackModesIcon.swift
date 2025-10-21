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
        HStack {
            if isLiked {
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
        if track.Playback_Explicit != nil {
            selectedExplicit = true
        }
        selectedExplicit = false
    }
    
    private func updateIsLikedInstant() {
        withAnimation {
            isLiked = omUser.isSongLiked(track: track)
        }
    }
    
    private func updateIsLiked() {
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { _ in
            DispatchQueue.main.async {
                updateIsLikedInstant()
            }
        }
    }
}

#Preview {
    PlaybackModesIcon(track: FetchedTrack())
}
