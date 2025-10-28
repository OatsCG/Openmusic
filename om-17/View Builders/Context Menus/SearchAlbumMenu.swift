//
//  SearchedAlbumMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-02.
//

import SwiftUI
import SwiftData

struct SearchAlbumMenu: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(BackgroundDatabase.self) private var database
    var searchedAlbum: SearchedAlbum
    @State var album: FetchedAlbum? = nil
    @State var arePlaybacksDownloaded: Bool = false
    @State var areTracksStored: Bool? = nil
    
    var body: some View {
        Group {
            if let album {
                if areTracksStored == true {
                    Button(role: .destructive, action: {
                        Task {
                            for track in album.Tracks {
                                if let fetchedTrack = await database.fetch_persistent_track(TrackID: track.TrackID) {
                                    await database.delete(fetchedTrack)
                                    try? database.save()
                                }
                            }
                        }
                    }) {
                        Label("Remove from Library", systemImage: "minus.circle")
                    }
                    if arePlaybacksDownloaded {
                        Button(role: .destructive, action: {
                            for track in album.Tracks {
                                if let Playback_Clean = track.Playback_Clean {
                                    downloadManager.delete_playback(PlaybackID: Playback_Clean)
                                }
                                if let Playback_Explicit = track.Playback_Explicit {
                                    downloadManager.delete_playback(PlaybackID: Playback_Explicit)
                                }
                            }
                        }) {
                            Label("Remove Downloads", systemImage: "trash")
                        }
                    } else {
                        Button(action: {
                            for track in album.Tracks {
                                Task {
                                    await downloadManager.addDownloadTask(track: track, explicit: track.Playback_Explicit != nil)
                                }
                            }
                        }) {
                            Label("Download Album", systemImage: "square.and.arrow.down")
                        }
                    }
                } else {
                    Button(action: {
                        Task {
                            await database.store_tracks(album.Tracks)
                        }
                    }) {
                        Label("Add to Library", systemImage: "plus.circle")
                    }
                }
                
                Section {
                    Menu {
                        ForEach(album.Artists, id: \.ArtistID) { artist in
                            NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                                Label(artist.Name, systemImage: "person.circle.fill")
                            }
                        }
                    } label: {
                        Label("Artists", systemImage: "person.fill")
                    }
                    
                    if !album.Features.isEmpty {
                        Menu {
                            ForEach(album.Features, id: \.ArtistID) { artist in
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
                    Button {
                        Task {
                            await playerManager.fresh_play_multiple(tracks: album.Tracks)
                        }
                    } label: {
                        Label("Play", systemImage: "play.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Menu {
                        Button {
                            Task {
                                await playerManager.queue_songs_next(tracks: album.Tracks)
                            }
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            Task {
                                await playerManager.queue_songs(tracks: album.Tracks)
                            }
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            Task {
                                await playerManager.queue_songs_randomly(tracks: album.Tracks)
                            }
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
                        Task {
                            await playerManager.fresh_play_multiple(tracks: album.Tracks.shuffled())
                        }
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Menu {
                        Button {
                            Task {
                                await playerManager.queue_songs_next(tracks: album.Tracks.shuffled())
                            }
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            Task {
                                await playerManager.queue_songs(tracks: album.Tracks.shuffled())
                            }
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                    } label: {
                        Label("Queue Shuffled", systemImage: "shuffle")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            } else {
                Label("Loading", systemImage: "circle.dashed")
                    .task {
                        if album == nil {
                            Task.detached {
                                let result: FetchedAlbum = try await fetchAlbumData(albumID: searchedAlbum.AlbumID)
                                await updateAlbum(result)
                            }
                        }
                    }
            }
        }
        .onAppear {
            Task {
                await updateArePlaybacksDownloaded()
                await updateAreTracksStored()
            }
        }
    }
    
    func updateAlbum(_ album: FetchedAlbum) async {
        await MainActor.run {
            self.album = album
        }
    }
    
    func updateArePlaybacksDownloaded() async {
        if let album {
            var toDetermineDownloadState: [String] = []
            for track in album.Tracks {
                if let Playback_Explicit = track.Playback_Explicit {
                    toDetermineDownloadState.append(Playback_Explicit)
                }
                if let Playback_Clean = track.Playback_Clean {
                    toDetermineDownloadState.append(Playback_Clean)
                }
            }
            let arePlaybacksDownloaded = await downloadManager.are_playbacks_downloaded(PlaybackIDs: toDetermineDownloadState)
            await MainActor.run {
                self.arePlaybacksDownloaded = arePlaybacksDownloaded
            }
        }
    }
    
    func updateAreTracksStored() async {
        if let album {
            let areTracksStored = await database.are_tracks_stored(tracks: album.Tracks)
            await MainActor.run {
                self.areTracksStored = areTracksStored
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, StoredTrack.self, configurations: config)
    let album = SearchedAlbum(default: true)
    
    return Menu("press me") {
        SearchAlbumMenu(searchedAlbum: album)
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
}
