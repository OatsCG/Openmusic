//
//  ArtistRowAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI

struct SearchArtistShelfAlbums: View {
    @Environment(FontManager.self) private var fontManager
    var albums: [SearchedAlbum]
    var artistName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchArtistExtendedAlbumsNPM(albums: albums, artistName: artistName)) {
                HStack {
                    Text("Albums")
                        .customFont(fontManager, .title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(albums.prefix(8), id: \.self) {album in
                        SearchAlbumLinkBig(album: album)
                    }
                }
                    .scrollTargetLayout()
            }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 10)
                .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
