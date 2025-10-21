//
//  LibraryAlbumsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibraryAlbumsList: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(BackgroundDatabase.self) private var database
    @Binding var tracks: [StoredTrack]
    @Binding var sortType: LibrarySortType
    @Binding var filterOnlyDownloaded: Bool
    @State var albumsTracks: Array<[StoredTrack]>?
    
    var body: some View {
        Group {
            if let albumsTracks {
                if albumsTracks.isEmpty {
                    ContentUnavailableView {
                        Label("No Music in Library", systemImage: "play.square.stack")
                    } description: {
                        Text("Add items to your library from Search or Explore to see them here.")
                    }
                } else {
                    VStack {
                        HStack {
                            Button(action: {
                                if !networkMonitor.isConnected {
                                    Task {
                                        await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(tracks.reversed()))
                                    }
                                } else {
                                    playerManager.fresh_play_multiple(tracks: tracks.reversed())
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
                            ForEach(albumsTracks, id: \.self) { albumTracks in
                                LibraryAlbumLink(tracks: albumTracks.sorted{$0.Index < $1.Index})
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .onAppear {
            updateAlbumTracks()
        }
        .onChange(of: tracks) {
            updateAlbumTracks()
        }
        .onChange(of: sortType) {
            updateAlbumTracks()
        }
        .onChange(of: filterOnlyDownloaded) {
            updateAlbumTracks()
        }
    }
    private func updateAlbumTracks() {
        Task {
            albumsTracks = nil
            
            let downloadedRespectedTracks: [StoredTrack]
            if filterOnlyDownloaded {
                downloadedRespectedTracks = await downloadManager.filter_downloaded(tracks)
            } else {
                downloadedRespectedTracks = tracks
            }
            
            let albums: Dictionary<String, [StoredTrack]> = Dictionary(grouping: downloadedRespectedTracks, by: { $0.Album.AlbumID })
            let albumTracks: Dictionary<String, [StoredTrack]>.Values = albums.values
            let albumTracksArr: Array<[StoredTrack]> = Array(albumTracks)
            
            var albumTracksSorted: Array<[StoredTrack]> = []
            
            for album in albumTracksArr {
                albumTracksSorted.append(album.sorted{$0.dateAdded > $1.dateAdded})
            }
            
            let albumsSorted: Array<[StoredTrack]>
            switch sortType {
            case .date_up:
                albumsSorted = albumTracksSorted.sorted{ $0[0].dateAdded > $1[0].dateAdded }
            case .date_down:
                albumsSorted = albumTracksSorted.sorted{ $0[0].dateAdded < $1[0].dateAdded }
            case .title_up:
                albumsSorted = albumTracksSorted.sorted{ $0[0].Album.Title < $1[0].Album.Title }
            case .title_down:
                albumsSorted = albumTracksSorted.sorted{ $0[0].Album.Title > $1[0].Album.Title }
            }
            
            await MainActor.run {
                albumsTracks = albumsSorted
            }
        }
    }
}
