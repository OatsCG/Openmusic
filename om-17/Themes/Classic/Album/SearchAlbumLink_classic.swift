//
//  SearchedAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_classic: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 80, BlurOpacity: 0.0, cornerRadius: 6.0)
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
                AlbumBackground(ArtworkID: album.Artwork, blur: 40, light_opacity: 0.2, dark_opacity: 0.5, spin: false)
            }
            .cornerRadius(8)
    }
}

#Preview {
    HStack {
        SearchAlbumLink_classic(album: SearchedAlbum(default: true))
        SearchAlbumLink_classic(album: SearchedAlbum(default: true))
    }
    .padding(10)
}

#Preview {
    SearchAlbumLink_classic(album: SearchedAlbum(default: true))
}

#Preview {
    LibraryAlbumLink_classic(tracks: [FetchedTrack(default: true)])
}
