//
//  PlaylistMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-31.
//

import SwiftUI
import SwiftData

struct PlaylistMenu: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    var playlist: StoredPlaylist
    var body: some View {
        Section {
            if (playlist.pinned == false) {
                Button {
                    self.playlist.pin()
                } label: {
                    Label("Pin Playlist", systemImage: "pin")
                        .symbolRenderingMode(.hierarchical)
                }
            } else {
                Button {
                    self.playlist.unpin()
                } label: {
                    Label("Unpin Playlist", systemImage: "pin.slash")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            
        }
        Section {
            Button {
                
                playerManager.fresh_play_multiple(tracks: playlist.items)
            } label: {
                Label("Play", systemImage: "play.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            
            Menu {
                Button {
                    playerManager.queue_songs_next(tracks: playlist.items)
                } label: {
                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                        .symbolRenderingMode(.hierarchical)
                }
                Button {
                    playerManager.queue_songs(tracks: playlist.items)
                } label: {
                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                        .symbolRenderingMode(.hierarchical)
                }
                Button {
                    playerManager.queue_songs_randomly(tracks: playlist.items)
                } label: {
                    Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                        .symbolRenderingMode(.hierarchical)
                }
            } label: {
                Label("Queue", systemImage: "forward.frame.fill")
                    .symbolRenderingMode(.hierarchical)
            }
        }
        
        Section {
            Button {
                playerManager.fresh_play_multiple(tracks: playlist.items.shuffled())
            } label: {
                Label("Shuffle", systemImage: "shuffle")
                    .symbolRenderingMode(.hierarchical)
            }
            
            Menu {
                Button {
                    playerManager.queue_songs_next(tracks: playlist.items.shuffled())
                } label: {
                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                        .symbolRenderingMode(.hierarchical)
                }
                Button {
                    playerManager.queue_songs(tracks: playlist.items.shuffled())
                } label: {
                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                        .symbolRenderingMode(.hierarchical)
                }
            } label: {
                Label("Queue Shuffled", systemImage: "shuffle")
                    .symbolRenderingMode(.hierarchical)
            }
        }
        

    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: StoredPlaylist.self, StoredTrack.self, configurations: config)
//    let album = SearchedAlbum(default: true)
//    return Menu("press me") {
//        SearchAlbumMenu(searchedAlbum: album)
//    }
//        .modelContainer(container)
//        .environment(PlayerManager())
//        .environment(PlaylistImporter())
//        .environment(DownloadManager())
//}
