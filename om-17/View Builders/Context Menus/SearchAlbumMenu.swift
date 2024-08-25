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
    @Environment(\.modelContext) private var modelContext
    var searchedAlbum: SearchedAlbum
    @State var album: FetchedAlbum? = nil
    var body: some View {
        if (album == nil) {
            Label("Loading", systemImage: "circle.dashed")
                .task {
                    if (album == nil) {
                        fetchAlbumData(AlbumID: searchedAlbum.AlbumID) { (result) in
                            switch result {
                            case .success(let data):
                                //self.album = data
                                Task {
                                    await self.updateAlbum(data)
                                }
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    }
            }
        } else {
            if are_tracks_stored(tracks: album!.Tracks, context: modelContext) {
                Button(role: .destructive, action: {
                    withAnimation {
                        for track in album!.Tracks {
                            modelContext.delete(fetch_persistent_track(TrackID: track.TrackID, context: modelContext)!)
                            try? modelContext.save()
                        }
                    }
                }) {
                    Label("Remove from Library", systemImage: "minus.circle")
                }
                if downloadManager.are_playbacks_downloaded(PlaybackIDs: album!.Tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!}) {
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
                            downloadManager.add_download_task(track: track, explicit: track.Playback_Explicit != nil)
                        }
                    }) {
                        Label("Download Album", systemImage: "square.and.arrow.down")
                    }
                }
            } else {
                Button(action: {
                    store_tracks(album!.Tracks, ctx: modelContext)
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
    func updateAlbum(_ album: FetchedAlbum) async {
        self.album = album
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
