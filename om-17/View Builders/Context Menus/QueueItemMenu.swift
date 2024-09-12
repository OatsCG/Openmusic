//
//  QueueItemMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-17.
//

import SwiftUI
import SwiftData

struct QueueItemMenu: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(OMUser.self) var omUser
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    @State var playlists: [StoredPlaylist] = []
    var queueItem: QueueItem
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    @State var isDownloaded: Bool = false
    @State var isTrackStored: Bool? = nil
    var body: some View {
        Section {
            if isTrackStored == true {
                Button(role: .destructive, action: {
                    Task {
                        if let fetchedTrack = await database.fetch_persistent_track(TrackID: queueItem.Track.TrackID) {
                            await database.delete(fetchedTrack)
                            try? database.save()
                        }
                    }
                }) {
                    Label("Remove from Library", systemImage: "minus.circle")
                }
            } else {
                Button(action: {
                    database.store_track(queueItem)
                }) {
                    Label("Add to Library", systemImage: "plus.circle")
                }
            }
            if playlists.count > 0 {
                Menu {
                    ForEach(playlists, id: \.PlaylistID) { playlist in
                        Button(action: {
                            playlist.add_track(queueItem: queueItem)
                        }) {
                            Label(playlist.Title, systemImage: itemInPlaylist(playlist: playlist, track: queueItem.Track) ? "checkmark" : "")
                        }
                    }
                } label: {
                    Label("Add to Playlist", systemImage: "music.note.list")
                }
            }
            if (omUser.isSongLiked(track: queueItem.Track)) {
                Button(action: {
                    omUser.removeLikedSong(track: queueItem.Track)
                }) {
                    Label("Unlove Song", systemImage: "heart.slash.fill")
                }
            } else {
                Button(action: {
                    omUser.addLikedSong(track: queueItem.Track)
                }) {
                    Label("Love Song", systemImage: "heart")
                }
            }
        }
        Section {
            Button(action: {
                passedNSPath.append(SearchAlbumContentNPM(album: queueItem.Track.Album))
                showingNPSheet = false
            }) {
                Label("Album", systemImage: "play.square.fill")
                Text(queueItem.Track.Album.Title)
            }
            Menu {
                ForEach(queueItem.Track.Album.Artists, id: \.ArtistID) { artist in
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
            
            if !queueItem.Track.Features.isEmpty {
                Menu {
                    ForEach(queueItem.Track.Features, id: \.ArtistID) { artist in
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
            if (queueItem.Track.Playback_Clean != nil && queueItem.Track.Playback_Explicit != nil) {
                Button(action: {
                    queueItem.explicit.toggle()
                    queueItem.prime_object_fresh(playerManager: playerManager)
                }) {
                    Label("Toggle Explicity", systemImage: "arrow.left.arrow.right.square")
                    //arrow.left.arrow.right.square
                    //square.on.square.dashed
                }
            }
            if isDownloaded {
                Button(role: .destructive) {
                    downloadManager.delete_playback(PlaybackID: queueItem.explicit ? queueItem.Track.Playback_Explicit! : queueItem.Track.Playback_Clean!)
                } label: {
                    Label("Remove Download", systemImage: "trash")
                        .symbolRenderingMode(.multicolor)
                }
            } else {
                Button {
                    downloadManager.addDownloadTask(track: StoredTrack(from: queueItem), explicit: queueItem.explicit)
                } label: {
                    Label("Download", systemImage: "square.and.arrow.down")
                        .symbolRenderingMode(.hierarchical)
                    Text(queueItem.explicit ? "Explicit" : "Clean")
                }
            }
        }
        Section {
            Button(action: {
                withAnimation {
                    playerManager.trackQueue.move(fromOffsets: IndexSet(integer: playerManager.trackQueue.firstIndex(where: {$0.queueID == queueItem.queueID}) ?? 0), toOffset: 0)
                }
                playerManager.prime_next_song()
            }) {
                Label("Move to Top", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button(action: {
                withAnimation {
                    playerManager.trackQueue.move(fromOffsets: IndexSet(integer: playerManager.trackQueue.firstIndex(where: {$0.queueID == queueItem.queueID}) ?? 0), toOffset: Int.random(in: 1..<(playerManager.trackQueue.count)))
                }
                playerManager.prime_next_song()
            }) {
                Label("Move Randomly", systemImage: "arrow.up.and.down.text.horizontal")
            }
            Button(action: {
                Task {
                    let copiedQueueItem: QueueItem = await QueueItem(from: queueItem)
                    await MainActor.run {
                        if let track = copiedQueueItem.Track as? ImportedTrack {
                            copiedQueueItem.Track = FetchedTrack(from: track)
                        }
                        withAnimation {
                            playerManager.trackQueue.insert(copiedQueueItem, at: playerManager.trackQueue.firstIndex(where: {$0.queueID == queueItem.queueID}) ?? 0)
                        }
                        playerManager.prime_next_song()
                    }
                }
            }) {
                Label("Duplicate in Queue", systemImage: "plus.square.on.square")
            }
            Button(role: .destructive, action: {
                withAnimation {
                    playerManager.trackQueue.removeAll(where: {$0.queueID == queueItem.queueID})
                }
                playerManager.prime_next_song()
            }) {
                Label("Remove From Queue", systemImage: "minus.circle")
            }
        }
        .onAppear {
            Task {
                await updateIsDownloaded()
                await updateIsTrackStored()
                self.updatePlaylists()
            }
        }
        
    }
    func updateIsDownloaded() async {
        let isDownloaded = await downloadManager.is_downloaded(queueItem, explicit: queueItem.explicit)
        await MainActor.run {
            self.isDownloaded = isDownloaded
        }
    }
    func updateIsTrackStored() async {
        let isTrackStored = await database.is_track_stored(TrackID: queueItem.Track.TrackID)
        await MainActor.run {
            self.isTrackStored = isTrackStored
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

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
//    let playerManager = PlayerManager()
//    let playlist = StoredPlaylist(Title: "Test!")
//    container.mainContext.insert(playlist)
//    return Menu("PRESS ME!") {
//        QueueItemMenu(queueItem: QueueItem(globalPlayerManager: playerManager, from: FetchedTrack(default: true), explicit: true))
//            .modelContainer(container)
//            .environment(playerManager)
//            .environment(DownloadManager())
//    }
//}
