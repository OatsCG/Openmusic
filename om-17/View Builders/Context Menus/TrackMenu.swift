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
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \StoredPlaylist.dateCreated) private var playlists: [StoredPlaylist]
    var track: any Track
    @State var isDownloadedExp: Bool = false
    @State var isDownloadedClean: Bool = false
    var body: some View {
        Section {
            if is_track_stored(TrackID: track.TrackID, context: modelContext) {
                Button(role: .destructive, action: {
                    withAnimation {
                        modelContext.delete(fetch_persistent_track(TrackID: track.TrackID, context: modelContext)!)
                        try? modelContext.save()
                    }
                }) {
                    Label("Remove from Library", systemImage: "minus.circle")
                }
            } else {
                Button(action: {
                    store_track(track, ctx: modelContext)
                }) {
                    Label("Add to Library", systemImage: "plus.circle")
                }
            }
            if playlists.count > 0 {
                Menu {
                    ForEach(playlists, id: \.PlaylistID) { playlist in
                        Button(action: {
                            playlist.add_track(track: track)
                        }) {
                            Label(playlist.Title, systemImage: itemInPlaylist(playlist: playlist, track: track) ? "checkmark" : "")
                        }
                    }
                } label: {
                    Label("Add to Playlist", systemImage: "music.note.list")
                }
            }
            if (omUser.isSongLiked(track: track)) {
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
                        if isDownloadedClean {
                            Button(role: .destructive) {
                                downloadManager.delete_playback(PlaybackID: track.Playback_Clean!)
                                //print("REMOVE DOWNLOAD \(track.Playback_Clean!)")
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
                    if isDownloadedClean {
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
                        if isDownloadedExp {
                            Button(role: .destructive) {
                                downloadManager.delete_playback(PlaybackID: track.Playback_Explicit!)
                                //print("REMOVE DOWNLOAD \(track.Playback_Explicit!)")
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
                    if isDownloadedExp {
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
                    if isDownloadedClean {
                        Button(role: .destructive) {
                            downloadManager.delete_playback(PlaybackID: track.Playback_Clean!)
                            //print("REMOVE DOWNLOAD \(track.Playback_Clean!)")
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
                            Text("Clean")
                        }
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
                    if isDownloadedExp {
                        Button(role: .destructive) {
                            downloadManager.delete_playback(PlaybackID: track.Playback_Explicit!)
                            //print("REMOVE DOWNLOAD \(track.Playback_Explicit!)")
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
                            Text("Explicit")
                        }
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
            }
        }
    }
    func updateIsDownloaded() async {
        isDownloadedExp = await downloadManager.is_downloaded(track, explicit: true)
        isDownloadedClean = await downloadManager.is_downloaded(track, explicit: false)
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
