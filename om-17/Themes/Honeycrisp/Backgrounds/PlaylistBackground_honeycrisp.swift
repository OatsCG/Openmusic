//
//  PlaylistBackground_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_honeycrisp: View {
    var playlist: Playlist
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            if (colorScheme == .dark) {
                Color(.black)
            } else {
                Color(.white)
            }
        }
            .ignoresSafeArea()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_classic(playlist: playlist)
        .modelContainer(container)
}
