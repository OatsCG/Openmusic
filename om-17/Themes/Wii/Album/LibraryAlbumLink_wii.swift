//
//  LibraryAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_wii: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0.0, cornerRadius: 8.0)
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
                TVStaticBackground()
                    .opacity(0.8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
            //.cornerRadius(8)
    }
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    return HStack {
        LibraryAlbumLink_component(tracks: [FetchedTrack(default: true)])
        LibraryAlbumLink_component(tracks: [FetchedTrack(default: true)])
    }
        .padding(10)
        .task {
            currentTheme = "wii"
        }
}
