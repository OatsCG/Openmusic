//
//  LiveImportingRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-15.
//

import SwiftUI

struct LiveImportingRow: View {
    @Environment(FontManager.self) private var fontManager
    var playlist: ImportedPlaylist
    var body: some View {
        HStack {
            //AlbumArtDisplay(ArtworkID: download.parent.Album.Artwork, Resolution: 480, Blur: 0, BlurOpacity: 0, cornerRadius: 4)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(playlist.Title)
                        .customFont(fontManager, .callout)
                }
                HStack {
                    Text("From: \(playlist.importURL ?? "unknown")")
                        .customFont(fontManager, .subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            LiveImportStatus(playlist: playlist)
        }
            //.aspectRatio(8 / 1, contentMode: .fit)
            .frame(height: 51)
            .listRowBackground(Color.clear)
    }
}
