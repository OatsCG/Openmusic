//
//  PlaylistBackground_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_spotty: View {
    var playlist: Playlist
    var body: some View {
        VStack {
            Rectangle().fill(Color(white: 0.07))
        }
            .ignoresSafeArea()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_spotty(playlist: playlist)
        .modelContainer(container)
}
