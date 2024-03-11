//
//  SearchRowAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchShelfAlbums: View {
    var viewModel: SearchViewModel
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SearchExtendedAlbumsNPM(albums: viewModel.searchResults?.Albums)) {
                HStack {
                    Text("Albums")
                        .customFont(.title2, bold: true)
                        .padding(.leading, 15)
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(.callout, bold: true)
                }
            }
                .buttonStyle(.plain)
            ScrollView(.horizontal) {
                HStackWrapped(rows: viewModel.searchResults?.Albums.count ?? 0 >= 2 ? 2 : 1) {
                    ForEach(viewModel.searchResults?.Albums.prefix(18) ?? [], id: \.self) {album in
                        SearchAlbumLink(album: album, fill: false)
                            //.frame(height: 300)
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
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}

#Preview {
    let view = SearchViewModel()
    return NavigationStack {
        ScrollView {
            VStack {
                ScrollView(.horizontal) {
                    HStackWrapped(rows: 2) {
                        SearchAlbumLink(album: SearchedAlbum(default: true), fill: false)
                        SearchAlbumLink(album: SearchedAlbum(default: true), fill: false)
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
