//
//  SearchExtendedAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct SearchExtendedAlbums: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var viewActor: ExploreViewActor = ExploreViewActor()
    @State var albums: [SearchedAlbum]?
    @State var type: ExploreType = .none
    @State var isAppending: Bool = false
    @State var currentPage: Int = 0
    @State var fetchedPages: [Int] = [0]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let albums {
                    if albums.isEmpty && !isAppending {
                        BrowseEmptyPage()
                            .onAppear {
                                requestNextPage()
                            }
                    } else {
                        VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                            ForEach(albums, id: \.AlbumID) { album in
                                SearchAlbumLink(album: album, fill: true)
                            }
                        }
                        .safeAreaPadding()
                        .padding(.top, 1)
                        Group {
                            if isAppending {
                                ProgressView()
                            } else {
                                Rectangle().fill(.clear)
                            }
                        }
                        .onAppear {
                            requestNextPage()
                        }
                    }
                } else {
                    ProgressView()
                }
            }
        }
            .background {
                GlobalBackground_component()
            }
            .onChange(of: type) {
                withAnimation {
                    albums = []
                    currentPage = 0
                    fetchedPages = []
                    isAppending = false
                }
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
    }
    
    func requestNextPage() {
        guard !isAppending else { return }
        guard NetworkManager.shared.networkService.supportedFeatures.contains(.isolatedExploreShelfFetch) else { return }
        let wantsPage: Int = !fetchedPages.contains(currentPage) ? currentPage : currentPage + 1
        guard !fetchedPages.contains(wantsPage) else { return }
        isAppending = true
        Task {
            do {
                try await viewActor.runSearch(type, wantsPage)
                let results = await viewActor.getExploreResults()
                await MainActor.run {
                    withAnimation {
                        albums?.append(contentsOf: results?.Shelves.first?.Albums ?? [])
                        if results?.Shelves.first?.Albums.count ?? 0 > 0 {
                            currentPage = wantsPage
                            fetchedPages.append(wantsPage)
                        }
                        isAppending = false
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        isAppending = false
                    }
                }
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    SearchExtendedAlbums()
}
