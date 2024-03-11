//
//  LiveImportingList.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-15.
//

import SwiftUI

struct LiveImportingList: View {
    @Environment(PlaylistImporter.self) var playlistImporter
    @State var expanded: Bool = false
    var body: some View {
        if (playlistImporter.newPlaylists.count > 0) {
            VStack {
                Button(action: {
                    withAnimation {
                        self.expanded = !self.expanded
                    }
                }) {
                    HStack {
                        Text("Importing")
                        Image(systemName: expanded ? "chevron.up.circle" : "chevron.down.circle")
                            .contentTransition(.symbolEffect(.replace.offUp))
                        Spacer()
                        //LiveDownloadSum()
                            //.frame(height: 16)
                    }
                }
                    .foregroundStyle(.primary)
                    .padding(.all, 10)
                    .background(.thinMaterial)
                List {
                    ForEach(playlistImporter.newPlaylists, id: \.PlaylistID) { playlist in
                        LiveImportingRow(playlist: playlist)
                    }
                }
                    .listStyle(PlainListStyle())
            }
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .containerRelativeFrame(.vertical, count: 10, span: expanded ? 8 : 4, spacing: 0)
        }
    }
}
