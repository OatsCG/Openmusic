//
//  LibrarySongMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-08.
//

import SwiftUI
import SwiftData

struct TrackMenu: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(FontManager.self) var fontManager
    @Environment(OMUser.self) var omUser
    @Environment(BackgroundDatabase.self) private var database
    @State var playlists: [StoredPlaylist]? = nil
    var track: any Track
    @State var isDownloadedExp: Bool? = nil
    @State var isDownloadedClean: Bool? = nil
    @State var isTrackStored: Bool? = nil
    
    var body: some View {
        Section {
            if let isTrackStored {
                if isTrackStored {
                    Button(role: .destructive, action: {
                        Task {
                            if let fetchedTrack = await database.fetch_persistent_track(TrackID: track.TrackID) {
                                await database.delete(fetchedTrack)
                                try? database.save()
                            }
                        }
                    }) {
                        Label("Remove from Library", systemImage: "minus.circle")
                    }
                } else {
                    Button(action: {
                        database.store_track(track)
                    }) {
                        Label("Add to Library", systemImage: "plus.circle")
                    }
                }
            } else {
                Label("Add to Library...", systemImage: "circle.dashed")
            }
            if let playlists {
                Menu {
                    if !playlists.isEmpty {
                        ForEach(playlists, id: \.PlaylistID) { playlist in
                            Button(action: {
                                playlist.add_track(track: track)
                                try? database.save()
                            }) {
                                Label(playlist.Title, systemImage: itemInPlaylist(playlist: playlist, track: track) ? "checkmark" : "")
                            }
                        }
                    } else {
                        Text("Create playlists in your Library")
                    }
                } label: {
                    Label("Add to Playlist", systemImage: "music.note.list")
                }
            } else {
                Label("Playlists...", systemImage: "circle.dashed")
            }
            if omUser.isSongLiked(track: track) {
                Button(action: {
                    omUser.removeLikedSong(track: track)
                }) {
                    Label("Unlove Song", systemImage: "heart.slash.fill")
                }
            } else {
                Button(action: {
                    omUser.addLikedSong(track: track)
                }) {
                    Label("Love Song", systemImage: "heart")
                }
            }
        }
        Section {
            NavigationLink(value: SearchAlbumContentNPM(album: track.Album)) {
                Label("Album", systemImage: "play.square.fill")
                Text(track.Album.Title)
            }
            Menu {
                ForEach(track.Album.Artists, id: \.ArtistID) { artist in
                    NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                        Label(artist.Name, systemImage: "person.circle.fill")
                    }
                }
            } label: {
                Label("Artists", systemImage: "person.fill")
            }
            
            if !track.Features.isEmpty {
                Menu {
                    ForEach(track.Features, id: \.ArtistID) { artist in
                        NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                            Label(artist.Name, systemImage: "person.circle.fill")
                        }
                    }
                } label: {
                    Label("Features", systemImage: "person.2.fill")
                }
            }
        }
        
        Section {
            if track.Playback_Clean != nil && track.Playback_Explicit != nil {
                Menu {
                    Section {
                        Button {
                            playerManager.fresh_play(track: track, explicit: false)
                        } label: {
                            Label("Play", systemImage: "play.fill")
                        }
                        if let isDownloadedClean {
                            if isDownloadedClean, let Playback_Clean = track.Playback_Clean {
                                Button(role: .destructive) {
                                    downloadManager.delete_playback(PlaybackID: Playback_Clean)
                                } label: {
                                    Label("Remove Download", systemImage: "trash")
                                        .symbolRenderingMode(.multicolor)
                                }
                            } else {
                                Button {
                                    downloadManager.addDownloadTask(track: track, explicit: false)
                                } label: {
                                    Label("Download", systemImage: "square.and.arrow.down")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        } else {
                            Label("Download...", systemImage: "circle.dashed")
                        }
                    }
                    Section {
                        Button {
                            playerManager.queue_next(track: track, explicit: false)
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_song(track: track, explicit: false)
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_randomly(track: track, explicit: false)
                        } label: {
                            Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                } label: {
                    Label("Clean", systemImage: "c.square")
                    if let isDownloadedClean, isDownloadedClean {
                        Text("Downloaded")
                    }
                }
                Menu {
                    Section {
                        Button {
                            playerManager.fresh_play(track: track, explicit: true)
                        } label: {
                            Label("Play", systemImage: "play.fill")
                        }
                        if let isDownloadedExp {
                            if isDownloadedExp, let Playback_Explicit = track.Playback_Explicit {
                                Button(role: .destructive) {
                                    downloadManager.delete_playback(PlaybackID: Playback_Explicit)
                                } label: {
                                    Label("Remove Download", systemImage: "trash")
                                        .symbolRenderingMode(.multicolor)
                                }
                            } else {
                                Button {
                                    downloadManager.addDownloadTask(track: track, explicit: true)
                                } label: {
                                    Label("Download", systemImage: "square.and.arrow.down")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        } else {
                            Label("Download...", systemImage: "circle.dashed")
                        }
                    }
                    Section {
                        Button {
                            playerManager.queue_next(track: track, explicit: true)
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_song(track: track, explicit: true)
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_randomly(track: track, explicit: true)
                        } label: {
                            Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                } label: {
                    Label("Explicit", systemImage: "e.square")
                    if let isDownloadedExp, isDownloadedExp {
                        Text("Downloaded")
                    }
                }
                Button {
                    playerManager.queue_song(track: track)
                } label: {
                    Label("Add to Queue", systemImage: "text.line.last.and.arrowtriangle.forward")
                        .symbolRenderingMode(.hierarchical)
                }
            } else if track.Playback_Clean != nil {
                Section {
                    Button {
                        playerManager.fresh_play(track: track, explicit: false)
                    } label: {
                        Label("Play", systemImage: "play.fill")
                    }
                    if let isDownloadedClean {
                        if isDownloadedClean, let Playback_Clean = track.Playback_Clean {
                            Button(role: .destructive) {
                                downloadManager.delete_playback(PlaybackID: Playback_Clean)
                            } label: {
                                Label("Remove Download", systemImage: "trash")
                                    .symbolRenderingMode(.multicolor)
                                Text("Clean")
                            }
                        } else {
                            Button {
                                downloadManager.addDownloadTask(track: track, explicit: false)
                            } label: {
                                Label("Download", systemImage: "square.and.arrow.down")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Clean")
                            }
                        }
                    } else {
                        Button {} label: {
                            Label("Download...", systemImage: "circle.dashed")
                            Text("Clean")
                        }
                        .disabled(true)
                    }
                }
                Section {
                    Button {
                        playerManager.queue_next(track: track, explicit: false)
                    } label: {
                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_song(track: track, explicit: false)
                    } label: {
                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_randomly(track: track, explicit: false)
                    } label: {
                        Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            } else if track.Playback_Explicit != nil {
                Section {
                    Button {
                        playerManager.fresh_play(track: track, explicit: true)
                    } label: {
                        Label("Play", systemImage: "play.fill")
                    }
                    if let isDownloadedExp {
                        if isDownloadedExp, let Playback_Explicit = track.Playback_Explicit {
                            Button(role: .destructive) {
                                downloadManager.delete_playback(PlaybackID: Playback_Explicit)
                            } label: {
                                Label("Remove Download", systemImage: "trash")
                                    .symbolRenderingMode(.multicolor)
                                Text("Explicit")
                            }
                        } else {
                            Button {
                                downloadManager.addDownloadTask(track: track, explicit: true)
                            } label: {
                                Label("Download", systemImage: "square.and.arrow.down")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Explicit")
                            }
                        }
                    } else {
                        Button {} label: {
                            Label("Download...", systemImage: "circle.dashed")
                            Text("Explicit")
                        }
                        .disabled(true)
                    }
                }
                Section {
                    Button {
                        playerManager.queue_next(track: track, explicit: true)
                    } label: {
                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_song(track: track, explicit: true)
                    } label: {
                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_randomly(track: track, explicit: true)
                    } label: {
                        Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
           }
        }
        .onAppear {
            Task {
                await updateIsDownloaded()
                await updateIsStored()
                updatePlaylists()
            }
        }
    }
    
    func updateIsDownloaded() async {
        let isDownloadedExp = await downloadManager.is_downloaded(track, explicit: true)
        let isDownloadedClean = await downloadManager.is_downloaded(track, explicit: false)
        await MainActor.run {
            self.isDownloadedExp = isDownloadedExp
            self.isDownloadedClean = isDownloadedClean
        }
    }
    
    func updateIsStored() async {
        let isStored = await database.is_track_stored(TrackID: track.TrackID)
        await MainActor.run {
            isTrackStored = isStored
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, StoredTrack.self, configurations: config)
    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return Menu("press me") {
        TrackMenu(track: FetchedTrack(default: true))
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
}
