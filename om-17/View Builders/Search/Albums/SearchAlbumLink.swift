//
//  AlbumButtonDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI

struct SearchAlbumLink: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var fill: Bool = false
    
    var body: some View {
        NavigationLink(value: SearchAlbumContentNPM(album: album)) {
            SearchAlbumLink_component(album: album, fill: fill)
        }
            .buttonStyle(.plain)
            .contextMenu {
                SearchAlbumMenu(searchedAlbum: album)
                    .environment(fontManager)
            } preview: {
                AlbumMenuPreview_component(album: album)
                    .environment(fontManager)
            }
    }
}

struct SearchAlbumLinkBig: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    
    var body: some View {
        NavigationLink(value: SearchAlbumContentNPM(album: album)) {
            SearchAlbumLinkBig_component(album: album)
        }
            .buttonStyle(.plain)
            .contextMenu {
                SearchAlbumMenu(searchedAlbum: album)
                    .environment(fontManager)
            } preview: {
                AlbumMenuPreview_component(album: album)
                    .environment(fontManager)
            }
    }
}

#Preview {
    SearchAlbumLink(album: SearchedAlbum())
}
