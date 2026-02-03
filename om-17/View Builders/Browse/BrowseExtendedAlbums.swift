//
//  BrowseExtendedAlbums.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-02-03.
//


import SwiftUI

struct BrowseExtendedAlbums: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var viewActor: ExploreViewActor = ExploreViewActor()
    @State var albums: [SearchedAlbum] = []
    @Binding var type: ExploreType
    @State var isAppending: Bool = false
    @State var currentPage: Int = 0
    @State var fetchedPages: [Int] = [0]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if albums.isEmpty {
                    if isAppending {
                        EmptyView()
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ContentUnavailableView {
                                    Label("No Albums to Display", systemImage: "exclamationmark.triangle")
                                } description: {
                                    Text("Try a different filter.")
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                } else {
                    VStackWrapped(columns: albumGridColumns_sizing(h: horizontalSizeClass, v: verticalSizeClass)) {
                        ForEach(albums, id: \.AlbumID) { album in
                            SearchAlbumLink(album: album, fill: true)
                        }
                    }
                    .safeAreaPadding()
                    .padding(.top, 1)
                }
                Group {
                    if isAppending {
                        ProgressView()
                    } else {
                        Rectangle().fill(.clear)
                            .frame(height: 1)
                    }
                }
                .onAppear {
                    requestNextPage()
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
                requestNextPage()
            }
            .navigationTitle(type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func requestNextPage() {
        guard !isAppending else { return }
        let wantsPage: Int = !fetchedPages.contains(currentPage) ? currentPage : currentPage + 1
        guard !fetchedPages.contains(wantsPage) else { return }
        isAppending = true
        Task {
            do {
                try await viewActor.runSearch(type, wantsPage)
                let results = await viewActor.getExploreResults()
                await MainActor.run {
                    withAnimation {
                        albums.append(contentsOf: results?.Shelves.first?.Albums ?? [])
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
