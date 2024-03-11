//
//  SearchArtistExtendedAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

struct SearchArtistExtendedAlbums: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var albums: [SearchedAlbum]?
    var artistName: String
    var body: some View {
        ScrollView {
            if albums == nil {
                ProgressView()
            } else {
                VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                    ForEach(albums!, id: \.AlbumID) { album in
                        SearchAlbumLink(album: album, fill: true)                        
                    }
                }
                .safeAreaPadding()
            }
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Albums by \(artistName)")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchArtistExtendedAlbums(albums: [SearchedAlbum(), SearchedAlbum(), SearchedAlbum(), SearchedAlbum(), SearchedAlbum()], artistName: "Kid Cudi")
}
