//
//  SearchArtistExtendedSingles.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

struct SearchArtistExtendedSingles: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var albums: [SearchedAlbum]?
    var artistName: String
    
    var body: some View {
        ScrollView {
            if let albums {
                VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                    ForEach(albums, id: \.AlbumID) { album in
                        SearchAlbumLink(album: album, fill: true)
                    }
                }
                .safeAreaPadding()
                .padding(.top, 1)
            } else {
                ProgressView()
            }
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Singles & EPs by \(artistName)")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchArtistExtendedSingles(albums: [SearchedAlbum(), SearchedAlbum(), SearchedAlbum(), SearchedAlbum(), SearchedAlbum()], artistName: "Kid Cudi")
}
