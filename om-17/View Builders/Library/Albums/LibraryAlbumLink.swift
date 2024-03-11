//
//  LibraryAlbum.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-07.
//

import SwiftUI

struct LibraryAlbumLink: View {
    var tracks: [StoredTrack]
    var fill: Bool = true
    var body: some View {
        NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: tracks))) {
            LibraryAlbumLink_component(tracks: tracks, fill: fill)
        }
            .buttonStyle(.plain)
            .contextMenu {
                LibraryAlbumMenu(album: StoredAlbum(from: tracks))
            } preview: {
                AlbumMenuPreview_component(album: StoredAlbum(from: tracks))
            }
    }
}
