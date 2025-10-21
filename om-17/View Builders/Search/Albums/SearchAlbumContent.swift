//
//  AlbumView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchAlbumContent: View {
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    @State var toastManager: ToastManager = ToastManager.shared
    var album: SearchedAlbum
    @State var albumModel = AlbumViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                SearchAlbumHeader(album: album, albumModel: $albumModel)
                    .background(Color.clear)
                    .textCase(nil)
                if albumModel.fetchedAlbum == nil {
                    LoadingTracklist_component()
                } else {
                    SearchAlbumTracklist(albumModel: $albumModel)
                }
            }
                .safeAreaPadding(.horizontal, 20)
                .padding(.top, 1)
        }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 160)
            .onAppear {
                if albumModel.fetchedAlbum == nil {
                    albumModel.runSearch(albumID: album.AlbumID, database: database)
                    Task {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        albumModel.runSearch(albumID: album.AlbumID, database: database)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 2) {
                        // Add to library
                        if albumModel.fetchedAlbum == nil || albumModel.areTracksStored == false {
                            Button (action: {
                                database.store_tracks((albumModel.fetchedAlbum?.Tracks ?? []))
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.title3)
                            }
                            .disabled((albumModel.fetchedAlbum?.Tracks.count ?? 0) == 0)
                        }
                        // Copy link
                        Button (action: {
                            let albumID: String = album.AlbumID
                            // https://server.openmusic.app/open/MPREb_NsEA96KDSAf
                            let link: String = "https://server.openmusic.app/open/\(albumID)"
                            UIPasteboard.general.string = link
                            toastManager.propose(toast: Toast.copylink(albumModel.fetchedAlbum?.Artwork))
                        }) {
                            Image(systemName: "link.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                        }
                        // Menu
                        Menu {
                            SearchAlbumMenu(searchedAlbum: album, album: albumModel.fetchedAlbum)
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
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
    return SearchAlbumContent(album: SearchedAlbum(default: true))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return SearchAlbumContent(album: SearchedAlbum(default: true))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
