//
//  LibraryArtist.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-09.
//

import SwiftUI

struct LibraryArtistLink: View {
    var artist: SearchedArtist
    var albums: [FetchedAlbum]? = []
    var features: [StoredTrack]? = []
    var body: some View {
        NavigationLink(value: LibraryArtistContentNPM(artist: artist, albums: albums ?? [], features: features ?? [])) {
            LibraryArtistLink_component(artist: artist)
        }
            .contextMenu {
                ArtistMenu(artist: artist)
            }
    }
}
