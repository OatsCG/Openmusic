//
//  AlbumButtonDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI

struct SearchAlbumLink: View {
    var album: SearchedAlbum
    var fill: Bool = false
    var body: some View {
        NavigationLink(value: SearchAlbumContentNPM(album: album)) {
            SearchAlbumLink_component(album: album, fill: fill)
        }
            .buttonStyle(.plain)
            .contextMenu {
                SearchAlbumMenu(searchedAlbum: album)
            } preview: {
                AlbumMenuPreview_component(album: album)
            }
    }
}

struct SearchAlbumLinkBig: View {
    var album: SearchedAlbum
    var body: some View {
        NavigationLink(value: SearchAlbumContentNPM(album: album)) {
            SearchAlbumLinkBig_component(album: album)
        }
            .buttonStyle(.plain)
            .contextMenu {
                SearchAlbumMenu(searchedAlbum: album)
            } preview: {
                AlbumMenuPreview_component(album: album)
            }
    }
}

#Preview {
    SearchAlbumLink(album: SearchedAlbum())
}
