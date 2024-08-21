//
//  SearchExtendedAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct SearchExtendedAlbums: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var albums: [SearchedAlbum]?
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
                .padding(.top, 1)
            }
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchExtendedAlbums()
}
