//
//  LibraryAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_classic: View {
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0.0, cornerRadius: 6.0)
            Text(tracks[0].Album.Title)
                .foregroundColor(.primary)
                .customFont(.callout)
            Text(stringArtists(artistlist: tracks[0].Album.Artists))
                .foregroundColor(.secondary)
                .customFont(.caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 4)
            .background {
                AlbumBackground(ArtworkID: tracks[0].Album.Artwork, blur: 40, light_opacity: 0.2, dark_opacity: 0.5, spin: false)
            }
            .cornerRadius(8)
    }
}

#Preview {
    HStack {
        LibraryAlbumLink_classic(tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_classic(tracks: [FetchedTrack(default: true)])
    }
    .padding(10)
}
