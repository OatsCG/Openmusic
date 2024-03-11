//
//  SearchRowSingles.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchShelfSingles: View {
    var viewModel: SearchViewModel
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedAlbumsNPM(albums: viewModel.searchResults?.Singles)) {
                HStack {
                    Text("Singles & EPs")
                        .customFont(.title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(.callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: viewModel.searchResults?.Singles.count ?? 0 >= 2 ? 2 : 1) {
                    ForEach(viewModel.searchResults?.Singles.prefix(18) ?? [], id: \.self) {single in
                        SearchAlbumLink(album: single)
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
