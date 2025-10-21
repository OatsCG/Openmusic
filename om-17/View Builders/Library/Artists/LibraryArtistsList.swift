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
    @Binding var tracks: [StoredTrack]
    @Binding var sortType: LibrarySortType
    @Binding var filterOnlyDownloaded: Bool
    @State var artistAlbums: [SearchedArtist : [FetchedAlbum]]? = [:]
    @State var artistFeatures: [SearchedArtist : [StoredTrack]]? = [:]
    @State var joinedArtists: [SearchedArtist]?
    
    var body: some View {
        Group {
            if let joinedArtists {
                VStack {
                    HStack {
                        Button(action: {
                            if !networkMonitor.isConnected {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks))
                                }
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
                                    Task {
                                        await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.reversed()))
                                    }
                                }) {
                                    Label("Play Downloaded", systemImage: "play.fill")
                                }
                            }
                        Button(action: {
                            if !networkMonitor.isConnected {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                                }
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
                                    Task {
                                        await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.shuffled()))
                                    }
                                }) {
                                    Label("Shuffle Downloaded", systemImage: "shuffle")
                                }
                            }
                    }
                    VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                        if let artistAlbums, let artistFeatures {
                            ForEach(joinedArtists, id: \.self) { artist in
                                LibraryArtistLink(artist: artist, albums: artistAlbums[artist], features: artistFeatures[artist])
                            }
                        }
                    }
                }
            } else {
                if tracks.isEmpty {
                    ContentUnavailableView {
                        Label("No Music in Library", systemImage: "music.mic")
                    } description: {
                        Text("Add items to your library from Search or Explore to see them here.")
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
        .onAppear {
            updateGroupedArtists()
        }
        .onChange(of: tracks) {
            updateGroupedArtists()
        }
        .onChange(of: sortType) {
            updateGroupedArtists()
        }
        .onChange(of: filterOnlyDownloaded) {
            updateGroupedArtists()
        }
    }
    
    func updateGroupedArtists() {
        joinedArtists = nil
        Task {
            let downloadedRespectedTracks: [StoredTrack] = await filterOnlyDownloaded ? downloadManager.filter_downloaded(tracks) : tracks
            let dateSortedTracks: [StoredTrack]
            switch sortType {
            case .date_up:
                dateSortedTracks = downloadedRespectedTracks.sorted{ $0.dateAdded > $1.dateAdded }
            case .date_down:
                dateSortedTracks = downloadedRespectedTracks.sorted{ $0.dateAdded < $1.dateAdded }
            default:
                dateSortedTracks = downloadedRespectedTracks
            }
            let g = groupArtists(tracks: dateSortedTracks)
            let artistAlbums = g.0
            let artistFeatures = g.1
            await MainActor.run {
                self.artistAlbums = artistAlbums
                self.artistFeatures = artistFeatures
            }
            let joined: [SearchedArtist] = Array(Set(Array(artistAlbums.keys) + Array(artistFeatures.keys)))
            let sortedJoined: [SearchedArtist]
            switch sortType {
            case .title_up:
                sortedJoined = joined.sorted{ $0.Name < $1.Name }
            case .title_down:
                sortedJoined = joined.sorted{ $0.Name > $1.Name }
            default:
                sortedJoined = joined
            }
            await MainActor.run {
                joinedArtists = sortedJoined
            }
        }
    }
}

#Preview {
    LibraryPage(libraryNSPath: .constant(NavigationPath()))
}
