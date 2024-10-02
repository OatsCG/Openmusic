//
//  ExploreRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI
import SwiftData

struct ExploreShelfView: View {
    @Environment(FontManager.self) private var fontManager
    var exploreShelf: ExploreShelf
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedAlbumsNPM(albums: exploreShelf.Albums)) {
                HStack {
                    Text(exploreShelf.Title)
                        .customFont(fontManager, .title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: exploreShelf.Albums.count > 1 ? 2 : 1) {
//                HStack {
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
