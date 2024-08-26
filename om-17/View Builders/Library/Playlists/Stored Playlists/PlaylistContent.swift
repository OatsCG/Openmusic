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
                            Task {
                                await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success })))
                            }
                        } else {
                            playerManager.fresh_play_multiple(tracks: playlist.items.filter({ $0.importData.status == .success }))
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                    .buttonStyle(.plain)
                    
                    Button (action: {
                        if (!networkMonitor.isConnected) {
                            Task {
                                await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).shuffled()))
                            }
                        } else {
                            playerManager.fresh_play_multiple(tracks: playlist.items.filter({ $0.importData.status == .success }).shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                    .buttonStyle(.plain)
                    
                    Menu {
                        Section {
                            Button(action: {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).reversed()))
                                }
                            }) {
                                Label("Play Downloaded", systemImage: "square.and.arrow.down.fill")
                            }
                            Menu {
                                Menu {
                                    Button {
                                        playerManager.queue_songs_next(tracks: playlist.items.filter({ $0.importData.status == .success }))
                                    } label: {
                                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        playerManager.queue_songs(tracks: playlist.items.filter({ $0.importData.status == .success }))
                                    } label: {
                                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        playerManager.queue_songs_randomly(tracks: playlist.items.filter({ $0.importData.status == .success }))
                                    } label: {
                                        Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                } label: {
                                    Label("Queue", systemImage: "forward.frame.fill")
                                }
                                Menu {
                                    Button {
                                        Task {
                                            await playerManager.queue_songs_next(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success })))
                                        }
                                    } label: {
                                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        Task {
                                            await playerManager.queue_songs(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success })))
                                        }
                                    } label: {
                                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        Task {
                                            await playerManager.queue_songs_randomly(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success })))
                                        }
                                    } label: {
                                        Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                } label: {
                                    Label("Queue Downloaded", systemImage: "square.and.arrow.down.fill")
                                }
                            } label: {
                                Label("Ordered", systemImage: "play.fill")
                            }
                        }
                        
                        Section {
                            Button(action: {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).shuffled()))
                                }
                            }) {
                                Label("Shuffle Downloaded", systemImage: "square.and.arrow.down.fill")
                            }
                            Menu {
                                Menu {
                                    Button {
                                        playerManager.queue_songs_next(tracks: playlist.items.filter({ $0.importData.status == .success }).shuffled())
                                    } label: {
                                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        playerManager.queue_songs(tracks: playlist.items.filter({ $0.importData.status == .success }).shuffled())
                                    } label: {
                                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                } label: {
                                    Label("Queue", systemImage: "forward.frame.fill")
                                }
                                Menu {
                                    Button {
                                        Task {
                                            await playerManager.queue_songs_next(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).shuffled()))
                                        }
                                    } label: {
                                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                    Button {
                                        Task {
                                            await playerManager.queue_songs(tracks: downloadManager.filter_downloaded(playlist.items.filter({ $0.importData.status == .success }).shuffled()))
                                        }
                                    } label: {
                                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                } label: {
                                    Label("Queue Downloaded", systemImage: "square.and.arrow.down.fill")
                                }
                            } label: {
                                Label("Shuffled", systemImage: "shuffle")
                            }
                        }

                    } label: {
                        ZStack {
                            
                        }
                        Image(systemName: "ellipsis.circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.primary, .clear)
                            .font(.title)
                            .background {
                                AlbumWideButton_component(text: "", subtitle: "", ArtworkID: "")
                            }
                    }

                }
                    //.buttonStyle(.plain)
                    .foregroundStyle(.primary)
                Divider()
            }
                .safeAreaPadding(.horizontal, 20)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
                .foregroundStyle(.primary)
            
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
