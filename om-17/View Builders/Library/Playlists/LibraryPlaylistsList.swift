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
    @Query(sort: \StoredPlaylist.dateCreated, order: .reverse) private var playlists: [StoredPlaylist]
    @Binding var libraryNSPath: NavigationPath
    //var playlists: [Playlist]
    var body: some View {
        PlaylistCreationButtons(libraryNSPath: $libraryNSPath)
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
    }
}


