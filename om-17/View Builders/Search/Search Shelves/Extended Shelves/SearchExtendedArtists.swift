//
//  SearchExtendedArtists.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct SearchExtendedArtists: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var artists: [SearchedArtist]?
    var body: some View {
        ScrollView {
            if artists == nil {
                ProgressView()
            } else {
                VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                    ForEach(artists!, id: \.ArtistID) { artist in
                        SearchArtistLink(artist: artist)
                    }
                }
                .safeAreaPadding()
            }
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Artists")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    SearchExtendedArtists()
}
