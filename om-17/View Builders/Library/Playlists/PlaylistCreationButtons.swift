//
//  PlaylistCreationButtons.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct PlaylistCreationButtons: View {
    @State private var showingAddPlaylistAlert: Bool = false
    @State private var showingImportPlaylistSheet: Bool = false
    @State private var addPlaylistName: String = ""
    @State private var importPlaylistURL: String = ""
    @Environment(BackgroundDatabase.self) private var database
    @Binding var libraryNSPath: NavigationPath
    
    var body: some View {
        HStack {
            Button(action: {
                showingAddPlaylistAlert.toggle()
            }) {
                AlbumWideButton_component(text: "New Playlist", ArtworkID: "")
            }
                .buttonStyle(.plain)
                .alert("New Playlist", isPresented: $showingAddPlaylistAlert) {
                    TextField("Playlist Name", text: $addPlaylistName)
                        .autocorrectionDisabled()
                    Button(action: {
                        let playlist = StoredPlaylist(Title: addPlaylistName)
                        libraryNSPath.append(PlaylistContentNPM(playlist: playlist))
                        Task {
                            await database.insert(playlist)
                        }
                    }) {
                        Text("Create")
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
                .sheet(isPresented: $showingImportPlaylistSheet) {
                    ImportPlaylistSheet(isShowingSheet: $showingImportPlaylistSheet)
                }
            if NetworkManager.shared.networkService.supportedFeatures.contains(.playlistmatching) {
                Button(action: {
                    showingImportPlaylistSheet.toggle()
                }) {
                    AlbumWideButton_component(text: "Import Playlist", ArtworkID: "")
                }
                    .buttonStyle(.plain)
            }
        }
    }
}
