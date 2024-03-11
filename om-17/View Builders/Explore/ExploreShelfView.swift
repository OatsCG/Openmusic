//
//  ExploreRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI
import SwiftData

struct ExploreShelfView: View {
    var exploreShelf: ExploreShelf
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedAlbumsNPM(albums: exploreShelf.Albums)) {
                HStack {
                    Text(exploreShelf.Title)
                        .customFont(.title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(.callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: exploreShelf.Albums.count > 1 ? 2 : 1) {
                    ForEach(exploreShelf.Albums.prefix(16), id: \.self) {album in
                        SearchAlbumLink(album: album)
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
