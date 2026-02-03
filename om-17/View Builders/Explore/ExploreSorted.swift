//
//  ExploreSorted.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-02-02.
//


import SwiftUI

struct ExploreSorted: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var albums: [SearchedAlbum]?
    @Binding var viewModel: ExploreViewModel
    
    var body: some View {
        LazyVStack {
            if let albums {
                VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                    ForEach(albums, id: \.AlbumID) { album in
                        SearchAlbumLink(album: album, fill: true)
                    }
                }
                .safeAreaPadding()
                .padding(.top, 1)
                Group {
                    if viewModel.isAppending {
                        ProgressView()
                    } else {
                        EmptyView()
                    }
                }
                .onAppear {
                    print("RMP: Appeared!")
                    viewModel.requestNextPage()
                }
            } else {
                ProgressView()
            }
        }
            .background {
                GlobalBackground_component()
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchExtendedAlbums()
}
