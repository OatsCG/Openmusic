//
//  PlaylistBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_classic: View {
    var playlist: Playlist
    var body: some View {
        PlaylistBackground(playlist: playlist, blur: 60, light_opacity: 0.15, dark_opacity: 0.15, spin: false, material: false)
            .allowsHitTesting(false)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_classic(playlist: playlist)
        .modelContainer(container)
}
