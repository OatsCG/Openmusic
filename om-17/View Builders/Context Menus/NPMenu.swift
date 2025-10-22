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
    @Environment(BackgroundDatabase.self) private var database
    var queueItem: QueueItem?
    @Binding var playlists: [StoredPlaylist]
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    @State var isDownloadedExp: Bool? = nil
    @State var isDownloadedClean: Bool? = nil
    @State var isTrackStored: Bool? = nil
    
    var body: some View {
        Group {
            if let queueItem {
                Section {
                    if let isTrackStored {
                        if isTrackStored {
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
                    } else {
                        Label("Add to Library...", systemImage: "circle.dashed")
                    }
                    if !playlists.isEmpty {
                        Menu {
                            ForEach(playlists, id: \.PlaylistID) { playlist in
                                Button(action: {
                                    playlist.add_track(queueItem: queueItem)
                                    try? database.save()
                                }) {
                                    Label(playlist.Title, systemImage: itemInPlaylist(playlist: playlist, track: queueItem.Track) ? "checkmark" : "")
                                }
                            }
                        } label: {
                            Label("Add to Playlist", systemImage: "music.note.list")
                        }
                    }
                    if omUser.isSongLiked(track: queueItem.Track) {
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
                    if queueItem.Track.Playback_Clean != nil && queueItem.Track.Playback_Explicit != nil {
                        Menu {
                            Section {
                                if let isDownloadedClean {
                                    if isDownloadedClean, let Playback_Clean = queueItem.Track.Playback_Clean {
                                        Button(role: .destructive) {
                                            downloadManager.delete_playback(PlaybackID: Playback_Clean)
                                        } label: {
                                            Label("Remove Download", systemImage: "trash")
                                                .symbolRenderingMode(.multicolor)
                                        }
                                    } else {
                                        Button {
                                            downloadManager.addDownloadTask(track: StoredTrack(from: queueItem), explicit: false)
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
                                    playerManager.queue_next(track: StoredTrack(from: queueItem), explicit: false)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_song(track: StoredTrack(from: queueItem), explicit: false)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_randomly(track: StoredTrack(from: queueItem), explicit: false)
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
                                if let isDownloadedExp {
                                    if isDownloadedExp, let Playback_Explicit = queueItem.Track.Playback_Explicit {
                                        Button(role: .destructive) {
                                            downloadManager.delete_playback(PlaybackID: Playback_Explicit)
                                        } label: {
                                            Label("Remove Download", systemImage: "trash")
                                                .symbolRenderingMode(.multicolor)
                                        }
                                    } else {
                                        Button {
                                            downloadManager.addDownloadTask(track: StoredTrack(from: queueItem), explicit: true)
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
                                    playerManager.queue_next(track: StoredTrack(from: queueItem), explicit: true)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_song(track: StoredTrack(from: queueItem), explicit: true)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_randomly(track: StoredTrack(from: queueItem), explicit: true)
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
                            playerManager.queue_song(track: StoredTrack(from: queueItem))
                        } label: {
                            Label("Add to Queue", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                    } else if queueItem.Track.Playback_Clean != nil {
                        Section {
                            if let isDownloadedClean {
                                if isDownloadedClean, let Playback_Clean = queueItem.Track.Playback_Clean {
                                    Button(role: .destructive) {
                                        downloadManager.delete_playback(PlaybackID: Playback_Clean)
                                    } label: {
                                        Label("Remove Download", systemImage: "trash")
                                            .symbolRenderingMode(.multicolor)
                                        Text("Clean")
                                    }
                                } else {
                                    Button {
                                        downloadManager.addDownloadTask(track: StoredTrack(from: queueItem), explicit: false)
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
                                playerManager.queue_next(track: StoredTrack(from: queueItem), explicit: false)
                            } label: {
                                Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_song(track: StoredTrack(from: queueItem), explicit: false)
                            } label: {
                                Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_randomly(track: StoredTrack(from: queueItem), explicit: false)
                            } label: {
                                Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    } else if queueItem.Track.Playback_Explicit != nil {
                        Section {
                            if let isDownloadedExp {
                                if isDownloadedExp, let Playback_Explicit = queueItem.Track.Playback_Explicit {
                                    Button(role: .destructive) {
                                        downloadManager.delete_playback(PlaybackID: Playback_Explicit)
                                        //print("REMOVE DOWNLOAD \(track!.Playback_Explicit!)")
                                    } label: {
                                        Label("Remove Download", systemImage: "trash")
                                            .symbolRenderingMode(.multicolor)
                                        Text("Explicit")
                                    }
                                } else {
                                    Button {
                                        downloadManager.addDownloadTask(track: StoredTrack(from: queueItem), explicit: true)
                                    } label: {
                                        Label("Download", systemImage: "square.and.arrow.down")
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
                                playerManager.queue_next(track: StoredTrack(from: queueItem), explicit: true)
                            } label: {
                                Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                 playerManager.queue_song(track: StoredTrack(from: queueItem), explicit: true)
                            } label: {
                                Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            Button {
                                playerManager.queue_randomly(track: StoredTrack(from: queueItem), explicit: true)
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
            } else {
                Text(playerManager.fetchSuggestionsModel.isFetching ? "Loading..." : "Not Playing")
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
        if let queueItem {
            let isDownloadedExp = await downloadManager.is_downloaded(queueItem, explicit: true)
            let isDownloadedClean = await downloadManager.is_downloaded(queueItem, explicit: false)
            await MainActor.run {
                self.isDownloadedExp = isDownloadedExp
                self.isDownloadedClean = isDownloadedClean
            }
        }
    }
    
    func updateIsTrackStored() async {
        if let queueItem {
            let isTrackStored = await database.is_track_stored(TrackID: queueItem.Track.TrackID)
            await MainActor.run {
                self.isTrackStored = isTrackStored
            }
        }
    }
}
