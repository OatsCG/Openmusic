//
//  SearchedAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_wii: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 80, BlurOpacity: 0.0, cornerRadius: 8.0)
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
                TVStaticBackground()
                    .opacity(0.8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
    }
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    return HStack {
        SearchAlbumLink_component(currentTheme: "wii", album: SearchedAlbum(default: true))
        SearchAlbumLink_component(currentTheme: "wii", album: SearchedAlbum(default: true))
    }
    .padding(10)
    .task {
        currentTheme = "wii"
    }
}
