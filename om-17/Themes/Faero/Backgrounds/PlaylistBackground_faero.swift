//
//  PlaylistBackground_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_faero: View {
    @Environment(\.colorScheme) private var colorScheme
    var playlist: Playlist
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            AeroBG().opacity(0.7)
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_faero(playlist: playlist)
        .modelContainer(container)
}
