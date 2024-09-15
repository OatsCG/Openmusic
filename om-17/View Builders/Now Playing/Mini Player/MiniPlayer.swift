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
    @Environment(BackgroundDatabase.self) var database  // was \.modelContext
    //@Query(sort: \StoredPlaylist.dateCreated) private var playlists: [StoredPlaylist]
    @State var playlists: [StoredPlaylist] = []
    @State private var showingNPSheet = false
    @State private var showingNPCover = false
    @Binding var passedNSPath: NavigationPath
    var minDistance: CGFloat = 30
    
    @Namespace var namespace
    
    var body: some View {
        VStack {
            Spacer()
                .allowsHitTesting(false)
            VStack(spacing: 10) {
                MiniToasts()
                MiniPlayer_component(namespace: namespace)
                    
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
                        NowPlayingSheet(showingNPSheet: $showingNPSheet, passedNSPath: $passedNSPath, namespace: namespace)
                            .environment(playerManager)
                            .environment(playlistImporter)
                            .environment(downloadManager)
                            .environment(networkMonitor)
                            .environment(omUser)
                            .navigationTransition(.zoom(sourceID: "NP_TRANSITION_ID", in: namespace))
                    })
                    .fullScreenCover(isPresented: $showingNPCover, content: {
                        NowPlayingSheet(showingNPSheet: $showingNPSheet, passedNSPath: $passedNSPath, namespace: namespace)
                            .environment(playerManager)
                            .environment(playlistImporter)
                            .environment(downloadManager)
                            .environment(networkMonitor)
                            .environment(omUser)
                            .navigationTransition(.zoom(sourceID: "NP_TRANSITION_ID", in: namespace))
                    })
                    .gesture(DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
                        .onEnded { value in
                            if (value.predictedEndTranslation.width > 200) {
                                playerManager.player_backward(userInitiated: true)
                            } else if (value.predictedEndTranslation.width < -200) {
                                playerManager.player_forward(userInitiated: true)
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
            .onAppear {
                self.updatePlaylists()
            }
    }
    func updatePlaylists() {
        Task {
            let predicate = #Predicate<StoredPlaylist> { _ in true }
            let sortDescriptors = [SortDescriptor(\StoredPlaylist.dateCreated, order: .reverse)]
            let playlists = try? await database.fetch(predicate, sortBy: sortDescriptors)
            if let playlists = playlists {
                await MainActor.run {
                    self.playlists = playlists
                }
            } else {
                await MainActor.run {
                    self.playlists = []
                }
            }
        }
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Previewable @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ContentView()
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .environment(FontManager())
        .environment(OMUser())
        .task {
            currentTheme = "classic"
//            globalIPAddress = "server.openmusic.app"
        }
}
