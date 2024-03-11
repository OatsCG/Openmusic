//
//  ArtistRowTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI

struct SearchArtistShelfTracks: View {
    var tracks: [any Track]
    var artistName: String
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchArtistExtendedTracksNPM(tracks: tracks, artistName: artistName)) {
                HStack {
                    Text("Tracks")
                        .customFont(.title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(.callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: tracks.count >= 3 ? 3 : (tracks.count == 2 ? 2 : 1)) {
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
    SearchArtistContent(artist: SearchedArtist())
}
