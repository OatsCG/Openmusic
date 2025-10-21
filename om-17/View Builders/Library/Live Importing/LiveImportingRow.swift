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
            .frame(height: 51)
            .listRowBackground(Color.clear)
    }
}
