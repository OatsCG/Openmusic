//
//  LibrarySongLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TrackLink_wii: View {
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 50, BlurOpacity: 0.8, cornerRadius: 8)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(track.Title)
                        .foregroundStyle(.primary)
                        .customFont(fontManager, .callout)
                    if (track.Features.count != 0) {
                        Text(" • " + stringArtists(artistlist: track.Features))
                            .customFont(fontManager, .subheadline)
                    }
                }
                Text(stringArtists(artistlist: track.Album.Artists))
                    .customFont(fontManager, .footnote)
            }
            Spacer()
            Text(secondsToText(seconds: track.Length))
                .customFont(fontManager, .subheadline)
            NavigationLink(value: SearchAlbumContentNPM(album: track.Album)) {
                Image(systemName: "chevron.forward.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
            }
        }
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding([.vertical, .leading], 5)
            .padding(.trailing, 10)
            .background {
                ZStack {
                    Rectangle().fill(.background)
                    TVStaticLines()
                        .opacity(0.4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .contentShape(Rectangle())
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
    }
}

#Preview {
    TrackLink_component(currentTheme: "wii", track: FetchedTrack(default: true))
}
