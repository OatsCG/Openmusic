//
//  LibraryArtistShelfFeatures.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-20.
//

import SwiftUI

struct LibraryArtistShelfFeatures: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var artistName: String
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchArtistExtendedTracksNPM(tracks: tracks, artistName: artistName)) {
                HStack {
                    Text("Featured On")
                        .customFont(fontManager, .title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: 1) {
                    ForEach(tracks.prefix(18), id: \.TrackID) {track in
                        SearchTrackLink(track: track)
                    }
                }
                    .scrollTargetLayout()
            }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 10)
                .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    LibraryArtistContent(artist: SearchedArtist(), albums: [], features: [
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack()
    ])
}
