//
//  SearchedTrackLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchTrackLink_spotty: View {
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var body: some View {
        VStack {
            HStack {
                AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
                VStack(alignment: .leading) {
                    Text(track.Title)
                        .customFont(fontManager, .callout)
                        .foregroundColor(.primary)
                    Text(stringArtists(artistlist: track.Album.Artists))
                        .customFont(fontManager, .caption)
                        .foregroundColor(.secondary)
                }
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
            }
        }
        .background {
            Rectangle().fill(Color(white: 0.15))
        }
            .cornerRadius(5)
            //.aspectRatio(3.0 / 1.0, contentMode: .fit)
    }
}

#Preview {
    SearchTrackLink_component(currentTheme: "spotty", track: FetchedTrack(default: true))
}
