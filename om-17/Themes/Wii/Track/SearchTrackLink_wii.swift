//
//  SearchedTrackLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchTrackLink_wii: View {
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .padding([.top, .bottom, .leading], 5)
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
                .padding(5)
            Spacer()
        }
            .background {
                ZStack {
                    Rectangle().fill(.background)
                    TVStaticLines()
                        .opacity(0.4)
                }
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
            //.aspectRatio(3.0 / 1.0, contentMode: .fit)
    }
}

#Preview {
    SearchTrackLink_component(currentTheme: "wii", track: FetchedTrack(default: true))
}
