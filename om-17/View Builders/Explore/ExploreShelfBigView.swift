//
//  ExploreShelfBigView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-01.
//

import SwiftUI

struct ExploreShelfBigView: View {
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
                HStackWrapped(rows: 1) {
                    ForEach(exploreShelf.Albums.prefix(10), id: \.self) {album in
                        SearchAlbumLinkBig(album: album)
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
