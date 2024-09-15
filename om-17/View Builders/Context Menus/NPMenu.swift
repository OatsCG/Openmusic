//
//  NPMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-31.
//

import SwiftUI
import SwiftData

struct NPMenu: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(OMUser.self) var omUser
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    var queueItem: QueueItem?
    @State var playlists: [StoredPlaylist]
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    @State var isDownloadedExp: Bool = false
    @State var isDownloadedClean: Bool = false
    @State var isTrackStored: Bool? = nil
    var body: some View {
        Group {
            if (queueItem == nil) {
                Text("Not Playing")
            } else {
                Section {
                    if isTrackStored == true {
                        Button(role: .destructive, action: {
                            Task {
                                if let fetchedTrack = await database.fetch_persistent_track(TrackID: queueItem!.Track.TrackID) {
                                    await database.delete(fetchedTrack)
                                    try? database.save()
                                }
                            }
                        }) {
                            Label("Remove from Library", systemImage: "minus.circle")
                        }
                    } else {
                        Button(action: {
                            database.store_track(queueItem!)
                        }) {
                            Label("Add to Library", systemImage: "plus.circle")
                        }
                    }
                    if playlists.count > 0 {
                        Menu {
                            ForEach(playlists, id: \.PlaylistID) { playlist in
                                Button(action: {
                                    
                                    playlist.add_track(queueItem: queueItem!)
                                }) {
                                    Label(playlist.Title, systemImage: itemInPlaylist(playlist: playlist, track: queueItem!.Track) ? "checkmark" : "")
                                }
                            }
                        } label: {
                            Label("Add to Playlist", systemImage: "music.note.list")
                        }
                    }
                    if (omUser.isSongLiked(track: queueItem!.Track)) {
                        Button(action: {
                            omUser.removeLikedSong(track: queueItem!.Track)
                        }) {
                            Label("Unlove Song", systemImage: "heart.slash.fill")
                        }
                    } else {
                        Button(action: {
                            omUser.addLikedSong(track: queueItem!.Track)
                        }) {
                            Label("Love Song", systemImage: "heart")
                        }
                    }
                }
                Section {
                    Button(action: {
                        passedNSPath.append(SearchAlbumContentNPM(album: queueItem!.Track.Album))
                        showingNPSheet = false
                    }) {
                        Label("Album", systemImage: "play.square.fill")
                        Text(queueItem!.Track.Album.Title)
                    }
                    Menu {
                        ForEach(queueItem!.Track.Album.Artists, id: \.ArtistID) { artist in
                            Button(action: {
                                passedNSPath.append(SearchArtistContentNPM(artist: artist))
                                showingNPSheet = false
                            }) {
                                Label(artist.Name, systemImage: "person.circle.fill")
                            }
                        }
                    } label: {
                        Label("Artists", systemImage: "person.fill")
                    }
                    
                    if !queueItem!.Track.Features.isEmpty {
                        Menu {
                            ForEach(queueItem!.Track.Features, id: \.ArtistID) { artist in
                                Button(action: {
                                    passedNSPath.append(SearchArtistContentNPM(artist: artist))
                                    showingNPSheet = false
                                }) {
                                    Label(artist.Name, systemImage: "person.circle.fill")
                                }
                            }
                        } label: {
                            Label("Features", systemImage: "person.2.fill")
                        }
                    }
                }
                Section {
                    if queueItem!.Track.Playback_Clean != nil && queueItem!.Track.Playback_Explicit != nil {
                        Menu {
                            Section {
                                if isDownloadedClean {
                                    Button(role: .destructive) {
                                        //print("REMOVE DOWNLOAD \(queueItem!.Playback_Clean!)")
                                        downloadManager.delete_playback(PlaybackID: queueItem!.Track.Playback_Clean!)
                                    } label: {
                                        Label("Remove Download", systemImage: "trash")
                                            .symbolRenderingMode(.multicolor)
                                    }
                                } else {
                                    Button {
                                        downloadManager.addDownloadTask(track: StoredTrack(from: queueItem!), explicit: false)
                                    } label: {
                                        Label("Download", systemImage: "square.and.arrow.down")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                            }
                            Section {
                                Button {
                                    playerManager.queue_next(track: StoredTrack(from: queueItem!), explicit: false)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_song(track: StoredTrack(from: queueItem!), explicit: false)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_randomly(track: StoredTrack(from: queueItem!), explicit: false)
                                } label: {
                                    Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        } label: {
                            Label("Clean", systemImage: "c.square")
                            if isDownloadedClean {
                                Text("Downloaded")
                            }
                        }
                        Menu {
                            Section {
                                if isDownloadedExp {
                                    Button(role: .destructive) {
                                        downloadManager.delete_playback(PlaybackID: queueItem!.Track.Playback_Explicit!)
                                        //print("REMOVE DOWNLOAD \(queueItem!.Playback_Explicit!)")
                                    } label: {
                                        Label("Remove Download", systemImage: "trash")
                                            .symbolRenderingMode(.multicolor)
                                    }
                                } else {
                                    Button {
                                        downloadManager.addDownloadTask(track: StoredTrack(from: queueItem!), explicit: true)
                                    } label: {
                                        Label("Download", systemImage: "square.and.arrow.down")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                            }
                            Section {
                                Button {
                                    playerManager.queue_next(track: StoredTrack(from: queueItem!), explicit: true)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_song(track: StoredTrack(from: queueItem!), explicit: true)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_randomly(track: StoredTrack(from: queueItem!), explicit: true)
                                } label: {
                                    Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        } label: {
                            Label("Explicit", systemImage: "e.square")
                            if isDownloadedExp {
                                Text("Downloaded")
                            }
                        }
                        Button {
                            playerManager.queue_song(track: StoredTrack(from: queueItem!))
                        } label: {
                            Label("Add to Queue", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                    } else if queueItem!.Track.Playback_Clean != nil {
                        Section {
                            if isDownloadedClean {
                                Button(role: .destructive) {
                                    //print("REMOVE DOWNLOAD \(track!.Playback_Clean!)")
                                    downloadManager.delete_playback(PlaybackID: queueItem!.Track.Playback_Clean!)
                                } label: {
                                    Label("Remove Download", systemImage: "trash")
                                        .symbolRenderingMode(.multicolor)
                                }
                            } else {
                                Button {
                                    downloadManager.addDownloadTask(track: StoredTrack(from: queueItem!), explicit: false)
                                } label: {
                                    Label("Download", systemImage: "square.and.arrow.down")
                                        .symbolRenderingMode(.hierarchical)
                                    Text("Clean")
                                }
                            }
                        }
                        Section {
                            Button {
                                playerManager.queue_next(track: StoredTrack(from: queueItem!), explicit: false)
                            } label: {
                                Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_song(track: StoredTrack(from: queueItem!), explicit: false)
                            } label: {
                                Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_randomly(track: StoredTrack(from: queueItem!), explicit: false)
                            } label: {
                                Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    } else if queueItem!.Track.Playback_Explicit != nil {
                        Section {
                            if isDownloadedExp {
                                Button(role: .destructive) {
                                    downloadManager.delete_playback(PlaybackID: queueItem!.Track.Playback_Explicit!)
                                    //print("REMOVE DOWNLOAD \(track!.Playback_Explicit!)")
                                } label: {
                                    Label("Remove Download", systemImage: "trash")
                                        .symbolRenderingMode(.multicolor)
                                }
                            } else {
                                Button {
                                    downloadManager.addDownloadTask(track: StoredTrack(from: queueItem!), explicit: true)
                                } label: {
                                    Label("Download", systemImage: "square.and.arrow.down")
                                    Text("Explicit")
                                }
                            }
                        }
                        Section {
                            Button {
                                playerManager.queue_next(track: StoredTrack(from: queueItem!), explicit: true)
                            } label: {
                                Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                 playerManager.queue_song(track: StoredTrack(from: queueItem!), explicit: true)
                            } label: {
                                Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_randomly(track: StoredTrack(from: queueItem!), explicit: true)
                            } label: {
                                Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    }
                }
                Section {
                    Button(role: .destructive) {
                        playerManager.clear_all_queue()
                    } label: {
                        Label("Clear Session", systemImage: "minus.circle")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await updateIsDownloaded()
                await updateIsTrackStored()
            }
        }
    }
    func updateIsDownloaded() async {
        if let queueItem = queueItem {
            let isDownloadedExp = await downloadManager.is_downloaded(queueItem, explicit: true)
            let isDownloadedClean = await downloadManager.is_downloaded(queueItem, explicit: false)
            await MainActor.run {
                self.isDownloadedExp = isDownloadedExp
                self.isDownloadedClean = isDownloadedClean
            }
        }
    }
    func updateIsTrackStored() async {
        if let queueItem = self.queueItem {
            let isTrackStored = await database.is_track_stored(TrackID: queueItem.Track.TrackID)
            await MainActor.run {
                self.isTrackStored = isTrackStored
            }
        }
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
//    let playerManager = PlayerManager()
//    let playlist = StoredPlaylist(Title: "Test!")
//    container.mainContext.insert(playlist)
//    return Menu("PRESS ME!") {
//        NPMenu(queueItem: QueueItem(globalPlayerManager: playerManager, from: FetchedTrack(default: true), explicit: true), playlists: [playlist])
//            .modelContainer(container)
//            .environment(playerManager)
//            .environment(DownloadManager())
//    }
//}
