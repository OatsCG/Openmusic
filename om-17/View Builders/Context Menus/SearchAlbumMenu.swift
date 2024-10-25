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
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    var searchedAlbum: SearchedAlbum
    @State var album: FetchedAlbum? = nil
    @State var arePlaybacksDownloaded: Bool = false // dont have to make this optional
    @State var areTracksStored: Bool? = nil
    var body: some View {
        Group {
            if (album == nil) {
                Label("Loading", systemImage: "circle.dashed")
                    .task {
                        if (album == nil) {
                            Task.detached {
                                let result: FetchedAlbum = try await fetchAlbumData(albumID: searchedAlbum.AlbumID)
                                await self.updateAlbum(result)
                            }
                        }
                    }
            } else {
                if areTracksStored == true {
                    Button(role: .destructive, action: {
                        Task {
                            for track in album!.Tracks {
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
                            for track in album!.Tracks {
                                if track.Playback_Clean != nil {
                                    downloadManager.delete_playback(PlaybackID: track.Playback_Clean!)
                                }
                                if track.Playback_Explicit != nil {
                                    downloadManager.delete_playback(PlaybackID: track.Playback_Explicit!)
                                }
                            }
                        }) {
                            Label("Remove Downloads", systemImage: "trash")
                        }
                    } else {
                        Button(action: {
                            for track in album!.Tracks {
                                downloadManager.addDownloadTask(track: track, explicit: track.Playback_Explicit != nil)
                            }
                        }) {
                            Label("Download Album", systemImage: "square.and.arrow.down")
                        }
                    }
                } else {
                    Button(action: {
                        database.store_tracks(album!.Tracks)
                    }) {
                        Label("Add to Library", systemImage: "plus.circle")
                    }
                }
                
                Section {
                    Menu {
                        ForEach(album!.Artists, id: \.ArtistID) { artist in
                            NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                                Label(artist.Name, systemImage: "person.circle.fill")
                            }
                        }
                    } label: {
                        Label("Artists", systemImage: "person.fill")
                    }
                    
                    if !album!.Features.isEmpty {
                        Menu {
                            ForEach(album!.Features, id: \.ArtistID) { artist in
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
                        playerManager.fresh_play_multiple(tracks: album!.Tracks)
                    } label: {
                        Label("Play", systemImage: "play.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Menu {
                        Button {
                            playerManager.queue_songs_next(tracks: album!.Tracks)
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_songs(tracks: album!.Tracks)
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_songs_randomly(tracks: album!.Tracks)
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
                        playerManager.fresh_play_multiple(tracks: album!.Tracks.shuffled())
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Menu {
                        Button {
                            playerManager.queue_songs_next(tracks: album!.Tracks.shuffled())
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            playerManager.queue_songs(tracks: album!.Tracks.shuffled())
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
        .onAppear {
            Task {
                await self.updateArePlaybacksDownloaded()
                await self.updateAreTracksStored()
            }
        }
    }
    func updateAlbum(_ album: FetchedAlbum) async {
        await MainActor.run {
            self.album = album
        }
    }
    func updateArePlaybacksDownloaded() async {
        if let album = self.album {
            let arePlaybacksDownloaded = await downloadManager.are_playbacks_downloaded(PlaybackIDs: album.Tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!})
            await MainActor.run {
                self.arePlaybacksDownloaded = arePlaybacksDownloaded
            }
        }
    }
    func updateAreTracksStored() async {
        if let album = self.album {
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
