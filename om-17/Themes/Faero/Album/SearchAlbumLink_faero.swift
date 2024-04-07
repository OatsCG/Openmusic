//
//  SearchedAlbumLink_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_faero: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 80, BlurOpacity: 0.0, cornerRadius: 6.0)
                .overlay {
                    AeroGlossOverlay(baseCornerRadius: 6, padding: 0)
                }
            Text(album.Title)
                .foregroundColor(.primary)
                .customFont(fontManager, .callout)
            Text(stringArtists(artistlist: album.Artists))
                .foregroundColor(.secondary)
                .customFont(fontManager, .caption)
            Spacer()
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
    SearchAlbumLink_faero(album: SearchedAlbum(default: true))
        SearchAlbumLink_faero(album: SearchedAlbum(default: true))
    }
    .padding(10)
}
