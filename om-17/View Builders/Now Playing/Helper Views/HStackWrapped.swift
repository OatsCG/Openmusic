//
//  HStackWrapped.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-27.
//

import SwiftUI

struct HStackWrapped<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let rows: Int
    let content: Content
    
    init(rows: Int, @ViewBuilder content: () -> Content) {
        self.rows = rows
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: rows)) {
                content
             }
        }
    }
}

#Preview {
    let view = SearchViewModel()
    return NavigationStack {
        ScrollView {
            VStack {
                ScrollView(.horizontal) {
                    HStackWrapped(rows: 2) {
                        SearchAlbumLink(album: SearchedAlbum(default: true), fill: false)
                        //SearchAlbumLink(album: SearchedAlbum(default: true), fill: false)
                    }
                        .scrollTargetLayout()
                }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 10)
                    .scrollIndicators(.hidden)
            }
        }
    }
    .environment(PlayerManager())
    .environment(PlaylistImporter())
    .environment(DownloadManager())
    .environment(NetworkMonitor())
    .task {
        view.runSearch(query: "testing rocky")
    }
}
