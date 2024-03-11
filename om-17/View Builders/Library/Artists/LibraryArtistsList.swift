//
//  LibraryArtistsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibraryArtistsList: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Query(sort: \StoredTrack.dateAdded) private var tracks: [StoredTrack]
    @State var artistAlbums: [SearchedArtist : [FetchedAlbum]]? = [:]
    @State var artistFeatures: [SearchedArtist : [StoredTrack]]? = [:]
    @State var joinedArtists: [SearchedArtist]?
    
    var body: some View {
        if tracks.count == 0 {
            ContentUnavailableView {
                Label("No Music in Library", systemImage: "music.mic")
            } description: {
                Text("Add items to your library from Search or Explore to see them here.")
            }
        } else {
            VStack {
                HStack {
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks))
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks)
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                        .contextMenu {
                            Button(action: {
                                playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.reversed()))
                            }) {
                                Label("Play Downloaded", systemImage: "play.fill")
                            }
                        }
                    Button(action: {
                        if (!networkMonitor.isConnected) {
                            playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                        } else {
                            playerManager.fresh_play_multiple(tracks: tracks.shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", subtitle: "Downloaded Only", ArtworkID: "")
                    }
                        .buttonStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                        .contextMenu {
                            Button(action: {
                                playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                            }) {
                                Label("Shuffle Downloaded", systemImage: "shuffle")
                            }
                        }
                }
                VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                    if joinedArtists != nil {
                        ForEach(joinedArtists!, id: \.self) { artist in
                            LibraryArtistLink(artist: artist, albums: artistAlbums![artist], features: artistFeatures![artist])
                        }
                    }
                }
            }
                .task {
                    Task.detached {
                        let g = groupArtists(tracks: tracks.sorted{$0.dateAdded > $1.dateAdded})
                        self.artistAlbums = g.0
                        self.artistFeatures = g.1
                        var joined: [SearchedArtist] = Array(Set(Array(artistAlbums!.keys) + Array(artistFeatures!.keys)))
                        let sortedJoined: [SearchedArtist] = joined.sorted(by: { $0.Name < $1.Name })
                        DispatchQueue.main.async {
                            self.joinedArtists = sortedJoined
                        }
                    }
                }
        }
    }
}

#Preview {
    LibraryPage(libraryNSPath: .constant(NavigationPath()))
}
