//
//  LibraryPlaylistEditMenuButton.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-31.
//

import SwiftUI

struct LibraryPlaylistEditMenuButton: View {
    var playlist: StoredPlaylist
    var body: some View {
        NavigationLink(value: PlaylistEditMenuNPM(playlist: playlist)) {
            if (getItemsMatching(items: playlist.items, status: [.uncertain]).count > 0) {
                Image(systemName: "gear")
                    .font(.title3)
                    .overlay(Badge())
            } else {
                Image(systemName: "gear")
                    .font(.title3)
            }
        }
    }
}


struct Badge: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text("!")
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .padding(5)
                .background(Color.red)
                .clipShape(Circle())
                // custom positioning in the top-right corner
                .alignmentGuide(.top) { $0[.bottom] }
                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
        }
    }
}

