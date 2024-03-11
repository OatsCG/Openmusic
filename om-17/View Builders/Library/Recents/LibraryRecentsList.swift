//
//  LibraryRecentsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibraryRecentsList: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Query(sort: \StoredTrack.dateAdded) private var tracks: [StoredTrack]
    var body: some View {
        if tracks.count == 0 {
            ContentUnavailableView {
                Label("No Music in Library", systemImage: "bookmark")
            } description: {
                Text("Add items to your library from Search or Explore to see them here.")
            }
        } else {
            LazyVStack {
                HStack {
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks))
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks)
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .clipped()
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button(action: {
                                playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.reversed()))
                            }) {
                                Label("Play Downloaded", systemImage: "play.fill")
                            }
                        }
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks.shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button(action: {
                                playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                            }) {
                                Label("Shuffle Downloaded", systemImage: "shuffle")
                            }
                        }
                }
                ForEach(Array(Dictionary(grouping: tracks, by: { $0.Album.AlbumID }).values).sorted{
                    //largest date in $0
                    $0.sorted{$0.dateAdded > $1.dateAdded}[0].dateAdded > $1.sorted{$0.dateAdded > $1.dateAdded}[0].dateAdded
                }, id: \.self) { albumTracks in
                    QuickplayItem(tracks: albumTracks)
                }
            }
        }
    }
}
