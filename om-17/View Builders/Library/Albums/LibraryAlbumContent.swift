//
//  AlbumViewDL.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-01.
//

import SwiftUI
import SwiftData

struct LibraryAlbumContent: View {
    @State var album: StoredAlbum
    var body: some View {
        ScrollView {
            VStack {
                LibraryAlbumHeader(album: album)
                    .background(Color.clear)
                    .textCase(nil)
                LibraryAlbumTracklist(tracks: album.Tracks)
            }
                .safeAreaPadding(.horizontal, 20)
                .padding(.top, 1)
        }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 160)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 2) {
                        // Download button
                        GroupDownloadButton(tracks: album.Tracks)
                        
                        // Album menu
                        Menu {
                            LibraryAlbumMenu(album: album)
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                        }
                        // Remote
                        NavigationLink(value: SearchAlbumContentNPM(album: SearchedAlbum(from: album))) {
                            Image(systemName: "globe")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                        }
                    }
                }
            }
            .background {
                AlbumBackground_component(artwork: album.Artwork)
            }
            .ignoresSafeArea()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    //let playlist = StoredPlaylist(Title: "Test!")
    return NavigationStack {
            LibraryAlbumContent(album: StoredAlbum(from: [FetchedTrack(default: true)]))
        }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
