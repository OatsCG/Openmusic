//
//  LibraryArtistShelfAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-20.
//

import SwiftUI

struct LibraryArtistShelfAlbums: View {
    @Environment(FontManager.self) private var fontManager
    var albums: [FetchedAlbum]
    var artistName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: LibraryArtistExtendedAlbumsNPM(albums: albums, artistName: artistName)) {
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
                HStackWrapped(rows: albums.count >= 2 ? 2 : 1) {
                    ForEach(albums.prefix(8), id: \.self) {album in
                        SearchAlbumLink(album: SearchedAlbum(from: album))
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
