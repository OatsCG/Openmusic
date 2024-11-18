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
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0.0, cornerRadius: 0.0)
                .scaledToFill()
//                .overlay {
//                    Rectangle()
//                        .fill(LinearGradient(
//                            stops: [
//                                .init(color: .white.opacity(0.1), location: 0.0),
//                                .init(color: .clear, location: 0.1),
//                            ],
//                            startPoint: .top,
//                            endPoint: .bottom
//                        ))
//                }
            VStack(alignment: .leading) {
                Text(tracks[0].Album.Title)
                    .foregroundColor(.primary)
                    .customFont(fontManager, .callout)
                Text(stringArtists(artistlist: tracks[0].Album.Artists))
                    .foregroundColor(.secondary)
                    .customFont(fontManager, .caption)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 8)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .background {
                AlbumBackground(ArtworkID: tracks[0].Album.Artwork, blur: 40, light_opacity: 0.05, dark_opacity: 0.5, spin: false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HStack {
        LibraryAlbumLink_linen(tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_linen(tracks: [FetchedTrack(default: true)])
    }
    .padding(10)
}
