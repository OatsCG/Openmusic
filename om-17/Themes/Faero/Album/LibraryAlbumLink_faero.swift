//
//  LibraryAlbumLink_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_faero: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0.0, cornerRadius: 6.0)
                .overlay {
                    AeroGlossOverlay(baseCornerRadius: 6, padding: 0)
                }
            Text(tracks[0].Album.Title)
                .foregroundColor(.primary)
                .customFont(fontManager, .callout)
            Text(stringArtists(artistlist: tracks[0].Album.Artists))
                .foregroundColor(.secondary)
                .customFont(fontManager, .caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 4)
            .background {
                AeroGlossBG(cornerRadius: 0)
            }
            .cornerRadius(8)
    }
}

#Preview {
    HStack {
    LibraryAlbumLink_faero(tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_faero(tracks: [FetchedTrack(default: true)])
    }
    .padding(10)
}
