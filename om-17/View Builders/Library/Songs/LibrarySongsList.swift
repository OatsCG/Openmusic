//
//  LibrarySongsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibrarySongsList: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Query(sort: \StoredTrack.dateAdded) private var tracks: [StoredTrack]
    var body: some View {
        if tracks.count == 0 {
            ContentUnavailableView {
                Label("No Music in Library", systemImage: "music.note")
            } description: {
                Text("Add items to your library from Search or Explore to see them here.")
            }
        } else {
            VStack {
                HStack {
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            Task {
                                await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks))
                            }
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks)
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                        .contextMenu {
                            Button(action: {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.reversed()))
                                }
                            }) {
                                Label("Play Downloaded", systemImage: "play.fill")
                            }
                        }
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            Task {
                                await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                            }
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks.shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                        .contextMenu {
                            Button(action: {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                                }
                            }) {
                                Label("Shuffle Downloaded", systemImage: "shuffle")
                            }
                        }
                }
                LazyVStack(spacing: 5) {
                    ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                        LibrarySongLink(track: track, songList: tracks, index: index)
                    }
                }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    LibraryPage(libraryNSPath: .constant(NavigationPath()))
}
