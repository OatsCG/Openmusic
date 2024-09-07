//
//  LibraryPlaylistsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI
import SwiftData

struct LibraryPlaylistsList: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    //@Query(sort: \StoredPlaylist.dateCreated, order: .reverse) private var playlists: [StoredPlaylist]
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    @State var playlists: [StoredPlaylist]? = nil
    @Binding var libraryNSPath: NavigationPath
    //var playlists: [Playlist]
    var body: some View {
        Group {
            PlaylistCreationButtons(libraryNSPath: $libraryNSPath)
            if let playlists = playlists {
                if playlists.isEmpty {
                    ContentUnavailableView {
                        Label("No Playlists", systemImage: "music.note.list")
                    } description: {
                        Text("Create a playlist, or import one from another platform here.")
                    }
                } else {
                    LazyVStack {
                        ForEach(playlists.filter{$0.pinned}, id: \.id) { playlist in
                            QPPlaylistLink(playlist: playlist)
                        }
                        ForEach(playlists.filter{!$0.pinned}, id: \.id) { playlist in
                            QPPlaylistLink(playlist: playlist)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            self.updatePlaylists()
        }
    }
    func updatePlaylists() {
        Task {
            let predicate = #Predicate<StoredPlaylist> { _ in true }
            let sortDescriptors = [SortDescriptor(\StoredPlaylist.dateCreated, order: .reverse)]
            let playlists = try? await database.fetch(predicate, sortBy: sortDescriptors)
            if let playlists = playlists {
                await MainActor.run {
                    self.playlists = playlists
                }
            } else {
                await MainActor.run {
                    self.playlists = []
                }
            }
        }
    }
}


