//
//  SearchRowArtists.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchShelfArtists: View {
    @Environment(FontManager.self) private var fontManager
    var viewModel: SearchViewModel
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedArtistsNPM(artists: viewModel.searchResults?.Artists)) {
                HStack {
                    Text("Artists")
                        .customFont(fontManager, .title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.searchResults?.Artists.prefix(10) ?? [], id: \.self) {artist in
                        SearchArtistLink(artist: artist)
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
