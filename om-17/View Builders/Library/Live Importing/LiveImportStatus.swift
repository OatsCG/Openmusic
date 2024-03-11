//
//  LiveImportStatus.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-15.
//

import SwiftUI

struct LiveImportStatus: View {
    @Environment(PlaylistImporter.self) var playlistImporter
    var playlist: ImportedPlaylist
    var body: some View {
        Group {
            if playlist.is_importing_successful() {
                HStack {
                    ProgressView()
                }
           } else if playlist.import_progress() == 0 {
                Image(systemName: "circle.dashed")
                    .imageScale(.large)
            } else {
                if let plist = playlistImporter.get_playlist(playlistID: playlist.PlaylistID) {
                    CircularProgressView(progress: plist.import_progress())
                }
            }
        }
    }
}
