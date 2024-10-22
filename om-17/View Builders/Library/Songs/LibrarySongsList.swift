//
//  LibrarySongsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibrarySongsList: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var tracks: [StoredTrack]
    @Binding var sortType: LibrarySortType
    @Binding var filterOnlyDownloaded: Bool
    @State var perceivedTracks: [StoredTrack] = []
    var body: some View {
        Group {
            if perceivedTracks.count == 0 {
                if tracks.count == 0 {
                    ContentUnavailableView {
                        Label("No Music in Library", systemImage: "music.note")
                    } description: {
                        Text("Add items to your library from Search or Explore to see them here.")
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            } else {
                VStack {
                    HStack {
                        Button(action: {
                            if (!networkMonitor.isConnected) {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(perceivedTracks))
                                }
                            } else {
                                playerManager.fresh_play_multiple(tracks: perceivedTracks)
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
                                        await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(perceivedTracks.reversed()))
                                    }
                                }) {
                                    Label("Play Downloaded", systemImage: "play.fill")
                                }
                            }
                        Button(action: {
                            if (!networkMonitor.isConnected) {
                                Task {
                                    await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(perceivedTracks.shuffled()))
                                }
                            } else {
                                playerManager.fresh_play_multiple(tracks: perceivedTracks.shuffled())
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
                                        await playerManager.fresh_play_multiple(tracks: downloadManager.filter_downloaded(perceivedTracks.shuffled()))
                                    }
                                }) {
                                    Label("Shuffle Downloaded", systemImage: "shuffle")
                                }
                            }
                    }
                    LazyVStack(spacing: 5) {
                        ForEach(Array(perceivedTracks.enumerated()), id: \.offset) { index, track in
                            LibrarySongLink(track: track, songList: perceivedTracks, index: index)
                        }
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .onAppear {
            self.updatePerceivedTracks()
        }
        .onChange(of: self.tracks) {
            self.updatePerceivedTracks()
        }
        .onChange(of: self.sortType) {
            self.updatePerceivedTracks()
        }
        .onChange(of: self.filterOnlyDownloaded) {
            self.updatePerceivedTracks()
        }
    }
    
    func updatePerceivedTracks() {
        self.perceivedTracks = []
        Task {
            let tracks: [StoredTrack] = self.tracks
            let downloadedRespectedTracks: [StoredTrack] = await self.filterOnlyDownloaded ? self.downloadManager.filter_downloaded(tracks) : tracks
            
            let songsSorted: [StoredTrack]
            switch self.sortType {
            case .date_up:
                songsSorted = downloadedRespectedTracks.sorted{ $0.dateAdded > $1.dateAdded }
            case .date_down:
                songsSorted = downloadedRespectedTracks.sorted{ $0.dateAdded < $1.dateAdded }
            case .title_up:
                songsSorted = downloadedRespectedTracks.sorted{ $0.Title < $1.Title }
            case .title_down:
                songsSorted = downloadedRespectedTracks.sorted{ $0.Title > $1.Title }
            }
            
            await MainActor.run {
                self.perceivedTracks = songsSorted
            }
        }
    }
}

#Preview {
    LibraryPage(libraryNSPath: .constant(NavigationPath()))
}
