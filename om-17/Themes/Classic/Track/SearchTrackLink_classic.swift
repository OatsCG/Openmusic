//
//  SearchedTrackLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchTrackLink_classic: View {
    var track: any Track
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 50, BlurOpacity: 0.8, cornerRadius: 8)
                .padding([.top, .bottom, .leading], 5)
            VStack(alignment: .leading) {
                Text(track.Title)
                    .customFont(.callout)
                    .foregroundColor(.primary)
                Text(stringArtists(artistlist: track.Album.Artists))
                    .customFont(.caption)
                    .foregroundColor(.secondary)
                    
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding(5)
            Spacer()
        }
            .background(.ultraThinMaterial)
            .cornerRadius(11)
            //.aspectRatio(3.0 / 1.0, contentMode: .fit)
    }
}

#Preview {
    SearchTrackLink_component(currentTheme: "classic", track: FetchedTrack(default: true))
}
