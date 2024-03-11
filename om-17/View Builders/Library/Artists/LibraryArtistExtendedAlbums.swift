//
//  LibraryArtistExtendedAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-20.
//

import SwiftUI

struct LibraryArtistExtendedAlbums: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var albums: [FetchedAlbum]
    var artistName: String
    var body: some View {
        ScrollView {
            VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                ForEach(albums, id: \.AlbumID) { album in
                    SearchAlbumLink(album: SearchedAlbum(from: album))
                }
            }
        }
            .navigationTitle("Albums by \(artistName)")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}
