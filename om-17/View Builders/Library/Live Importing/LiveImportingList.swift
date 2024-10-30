//
//  LiveImportingList.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-15.
//

import SwiftUI

struct LiveImportingList: View {
    @Environment(BackgroundDatabase.self) private var database
    @Environment(PlaylistImporter.self) var playlistImporter
    @Binding var playlists: [StoredPlaylist]?
    @State var expanded: Bool = false
    var body: some View {
        Group {
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
        .onChange(of: playlistImporter.newPlaylists) { oldValue, newValue in
            if newValue.isEmpty {
                self.updatePlaylists()
            }
        }
    }
    func updatePlaylists() {
        Task {
            let predicate = #Predicate<StoredPlaylist> { _ in true }
            let sortDescriptors = [SortDescriptor(\StoredPlaylist.dateCreated, order: .reverse)]
            let playlists = try? await database.fetch(predicate, sortBy: sortDescriptors)
            if let playlists = playlists {
                await MainActor.run {
                    withAnimation {
                        self.playlists = playlists
                    }
                }
            } else {
                await MainActor.run {
                    withAnimation {
                        self.playlists = []
                    }
                }
            }
        }
    }
}
