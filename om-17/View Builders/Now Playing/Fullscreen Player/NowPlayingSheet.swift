//
//  NowPlayingSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI
import SwiftData
import MarqueeText

struct NowPlayingSheet: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Query(sort: \StoredPlaylist.dateCreated) private var playlists: [StoredPlaylist]
    @Binding var showingNPSheet: Bool
    @State var fullscreen: Bool = false
    @State var carModeEnabled: Bool = false
    @Binding var passedNSPath: NavigationPath
    var body: some View {
        VStack {
            Button(action: {
                showingNPSheet = false
            }) {
                Image(systemName: "chevron.compact.down")
                    .customFont(.title)
                    .foregroundStyle(.tertiary)
                    .opacity(0.7)
            }
            if fullscreen {
                if carModeEnabled {
                    NPProximityWarning()
                }
            }
            VStack {
                if (verticalSizeClass == .compact || horizontalSizeClass == .regular) {
                    // landscape
                    HStack(spacing: 20) {
                        NPHeaderSegment(fullscreen: $fullscreen, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                        VStack {
                            Spacer()
                            NPInfoSegment(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath)
                            Spacer()
                            NPBottomToolBar(fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                        }
                    }
                } else {
                    // portrait
                    VStack {
                        Spacer()
                        NPHeaderSegment(fullscreen: $fullscreen, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                        NPInfoSegment(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath)
                        Spacer()
                        NPBottomToolBar(fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                    }
                }
            }
        }
            .safeAreaPadding(20)
            .tint(.primary)
            .background {
                NPBackground_component(album: playerManager.currentQueueItem?.Track.Album, fullscreen: $fullscreen)
            }
    }
}

//#Preview {
//    NowPlayingSheet()
//        .tint(.white)
//        .environment(PlayerManager())
////        .task {
////
////            PlayerManager.shared.currentQueueItem = QueueItem(from: FetchedTrack())
////        }
//}
