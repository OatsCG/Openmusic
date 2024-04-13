//
//  LibraryAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_honeycrisp: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 6.0)
            Text(tracks[0].Album.Title)
                .foregroundColor(.primary)
                .customFont(fontManager, .callout)
            Text(stringArtists(artistlist: tracks[0].Album.Artists))
                .foregroundColor(.secondary)
                .customFont(fontManager, .caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 2)
            .cornerRadius(10)
    }
}

#Preview {
    HStack {
        LibraryAlbumLink_component(currentTheme: "honeycrisp", tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_component(currentTheme: "honeycrisp", tracks: [FetchedTrack(default: true)])
    }
    .padding(10)
}

