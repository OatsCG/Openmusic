//
//  SearchRowTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchShelfTracks: View {
    @Environment(FontManager.self) private var fontManager
    var tracks: [FetchedTrack]?
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedTracksNPM(tracks: tracks, shouldQueueAll: false)) {
                HStack {
                    Text("Tracks")
                        .customFont(fontManager, .title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: tracks?.count ?? 0 >= 3 ? 3 : (tracks?.count ?? 0 == 2 ? 2 : 1)) {
                    ForEach(tracks?.prefix(18) ?? [], id: \.self) { track in
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
    ExplorePage(exploreNSPath: .constant(NavigationPath()))
}

