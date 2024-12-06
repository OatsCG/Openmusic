//
//  LibraryAlbumLink_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_linen: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 2.0)
                .shadow(radius: 4, x: 0, y: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 2.0)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .fill(.linearGradient(Gradient(stops: [.init(color: .white.opacity(0.18), location: 0.499), .init(color: .clear, location: 0.50)]), startPoint: .topLeading, endPoint: .bottomTrailing))
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
            .padding(.all, 2)
            .cornerRadius(10)
    }
}

#Preview {
    HStack {
        LibraryAlbumLink_linen(tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_linen(tracks: [FetchedTrack(default: true)])
    }
    .padding(10)
}
