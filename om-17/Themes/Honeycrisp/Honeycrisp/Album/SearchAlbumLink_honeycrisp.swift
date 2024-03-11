//
//  SearchedAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_honeycrisp: View {
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 6.0)
            Text(album.Title)
                .foregroundColor(.primary)
                .customFont(.callout)
            Text(stringArtists(artistlist: album.Artists))
                .foregroundColor(.secondary)
                .customFont(.caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 2)
            .cornerRadius(8)
    }
}

#Preview {
    HStack {
        SearchAlbumLink_component(currentTheme: "honeycrisp", album: SearchedAlbum(default: true))
        SearchAlbumLink_component(currentTheme: "honeycrisp", album: SearchedAlbum(default: true))
    }
    .padding(10)
}
