//
//  MiniPlayer.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-19.
//

import Foundation
import SwiftUI
import SwiftData
import MarqueeText

struct MiniPlayer: View {
    @AppStorage("NowPlayingUsesCover") var NowPlayingUsesCover: Bool = false
    @Environment(PlayerManager.self) var playerManager
    @Environment(PlaylistImporter.self) var playlistImporter
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(FontManager.self) private var fontManager
    @Environment(OMUser.self) var omUser
    @Query(sort: \StoredPlaylist.dateCreated) private var playlists: [StoredPlaylist]
    @State private var showingNPSheet = false
    @State private var showingNPCover = false
    @Binding var passedNSPath: NavigationPath
    var minDistance: CGFloat = 30
    var body: some View {
        VStack {
            Spacer()
                .allowsHitTesting(false)
            VStack(spacing: 10) {
                MiniToasts()
                MiniPlayer_component()
                    .contextMenu {
                        NPMenu(queueItem: playerManager.currentQueueItem, playlists: playlists, passedNSPath: $passedNSPath, showingNPSheet: .constant(true))
                            .environment(fontManager)
                    }
                    .onTapGesture {
                        if (NowPlayingUsesCover) {
                            showingNPCover.toggle()
                        } else {
                            showingNPSheet.toggle()
                        }
                    }
                    .sheet(isPresented: $showingNPSheet, content: {
                        NowPlayingSheet(showingNPSheet: $showingNPSheet, passedNSPath: $passedNSPath)
                            .environment(playerManager)
                            .environment(playlistImporter)
                            .environment(downloadManager)
                            .environment(networkMonitor)
                            .environment(omUser)
                    })
                    .fullScreenCover(isPresented: $showingNPCover, content: {
                        NowPlayingSheet(showingNPSheet: $showingNPCover, passedNSPath: $passedNSPath)
                            .environment(playerManager)
                            .environment(playlistImporter)
                            .environment(downloadManager)
                            .environment(networkMonitor)
                            .environment(omUser)
                    })
                    .gesture(DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
                        .onEnded { value in
                            if (value.predictedEndTranslation.width > 200) {
                                playerManager.player_backward()
                            } else if (value.predictedEndTranslation.width < -200) {
                                playerManager.player_forward()
                            } else if (value.predictedEndTranslation.height < -400) {
                                if (NowPlayingUsesCover) {
                                    showingNPCover.toggle()
                                } else {
                                    showingNPSheet.toggle()
                                }
                            }
                        }
                    )
            }
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
