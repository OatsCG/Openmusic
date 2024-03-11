//
//  PlaylistContent.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI
import SwiftData

struct PlaylistContent: View {
    var playlist: StoredPlaylist
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    var body: some View {
        List {
            VStack {
                PlaylistContentHeading_component(playlist: playlist)
                    //.safeAreaPadding(.top, 80)
                HStack(spacing: 10) {
                    Button (action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success })))
                        } else {
                            playerManager.fresh_play_multiple(tracks: playlist.items.filter({ $0.importData.status == .success }))
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                    
                    Button (action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).shuffled()))
                        } else {
                            playerManager.fresh_play_multiple(tracks: playlist.items.filter({ $0.importData.status == .success }).shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                }
                    .buttonStyle(.plain)
                    .foregroundStyle(.primary)
                Divider()
            }
                .safeAreaPadding(.horizontal, 20)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            PlaylistItemList(playlist: playlist)
        }
            .background(Color.clear)
            .listStyle(PlainListStyle())
            .scrollDismissesKeyboard(.interactively)
            .safeAreaPadding(.bottom, 160)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 2) {
                        LibraryPlaylistDownloadButton(playlist: playlist)
                        LibraryPlaylistEditMenuButton(playlist: playlist)
                    }
                }
            }
            .background {
                PlaylistBackground_component(playlist: playlist)
            }
            .ignoresSafeArea()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return NavigationStack {
        PlaylistContent(playlist: playlist)
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
