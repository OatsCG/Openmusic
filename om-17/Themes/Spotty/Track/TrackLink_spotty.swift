//
//  LibrarySongLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TrackLink_spotty: View {
    var track: any Track
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(track.Title)
                        .foregroundStyle(.primary)
                        .customFont(.callout)
                    if (track.Features.count != 0) {
                        Text(" • " + stringArtists(artistlist: track.Features))
                            .customFont(.subheadline)
                    }
                }
                Text(stringArtists(artistlist: track.Album.Artists))
                    .customFont(.footnote)
            }
            Spacer()
            Text(secondsToText(seconds: track.Length))
                .customFont(.subheadline)
            NavigationLink(value: SearchAlbumContentNPM(album: track.Album)) {
                Image(systemName: "chevron.forward.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
            }
        }
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding(8)
            .contentShape(Rectangle())
    }
}

#Preview {
    TrackLink_component(currentTheme: "honeycrisp", track: FetchedTrack(default: true))
}
