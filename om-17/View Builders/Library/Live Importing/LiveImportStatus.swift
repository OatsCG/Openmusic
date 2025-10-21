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
    @State var importProgress: Double = 0
    
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
                if playlistImporter.get_playlist(playlistID: playlist.PlaylistID) != nil {
                    CircularProgressView(progress: importProgress)
                }
            }
        }
        .onChange(of: playlist.import_progress()) { oldValue, newValue in
            withAnimation {
                importProgress = newValue
            }
        }
    }
}
