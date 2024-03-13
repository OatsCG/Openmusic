//
//  SearchedTrackLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchTrackLink_honeycrisp: View {
    var track: any Track
    var body: some View {
        VStack {
            Divider()
            Spacer()
            HStack {
                AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 6.0)
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
                Spacer()
            }
        }
            //.padding(.vertical, 4)
            .cornerRadius(8)
            //.aspectRatio(3.0 / 1.0, contentMode: .fit)
    }
}

#Preview {
    SearchTrackLink_component(currentTheme: "honeycrisp", track: FetchedTrack(default: true))
}
