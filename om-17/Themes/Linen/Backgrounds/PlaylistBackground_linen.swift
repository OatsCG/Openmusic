//
//  PlaylistBackground_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_linen: View {
    var playlist: Playlist
    var body: some View {
        ZStack {
            Image(.linenbg)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_linen(playlist: playlist)
        .modelContainer(container)
}
