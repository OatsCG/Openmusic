//
//  SearchPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI
import SwiftData
import Combine

struct SearchPage: View {
    @SceneStorage("recentSearches") var recentSearches: String = ""
    @State var viewModel: SearchViewModel = SearchViewModel()
    @State var quickViewModel: QuickSearchViewModel = QuickSearchViewModel()
    @State var searchField: String = ""
    @State private var qsTimer: Timer?
    @State private var rsTimer: Timer?
    @Binding var searchNSPath: NavigationPath
    var body: some View {
        ZStack {
            NavigationStack(path: $searchNSPath) {
                SearchResultsView(viewModel: $viewModel, quickViewModel: $quickViewModel, searchField: $searchField)
                    .safeAreaPadding(.top, 30)
                    .refreshable {
                        viewModel.runLastSearch()
                    }
                    .navigationBarTitle("Search")
                    .scrollDismissesKeyboard(.immediately)
                    .searchable(text: $searchField, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                    .autocorrectionDisabled()
                    
                    .onChange(of: searchField, {
                        resetTimers()
                        if viewModel.fullSearchSubmitted {
                            quickViewModel.fetchedTracks = nil
                            viewModel.lastSearch = ""
                            withAnimation {
                                viewModel.fullSearchSubmitted = false
                            }
                        }
                    })
                    .onSubmit(of: .search, {
                        add_recent()
                        viewModel.runSearch(query: searchField)
                    })
                    .task {
                        //viewModel.runSearch(query: "travis")
                    }
                    .background {
                        GlobalBackground_component()
                    }
                    .navigationDestination(for: SearchAlbumContentNPM.self) { npm in
                        SearchAlbumContent(album: npm.album)
                    }
                    .navigationDestination(for: LibraryAlbumContentNPM.self) { npm in
                        LibraryAlbumContent(album: npm.album)
                    }
                    .navigationDestination(for: SearchArtistContentNPM.self) { npm in
                        SearchArtistContent(artist: npm.artist)
                    }
                    .navigationDestination(for: LibraryArtistContentNPM.self) { npm in
                        LibraryArtistContent(artist: npm.artist, albums: npm.albums, features: npm.features)
                    }
                    .navigationDestination(for: SearchExtendedTracksNPM.self) { npm in
                        SearchExtendedTracks(tracks: npm.tracks, shouldQueueAll: npm.shouldQueueAll)
                    }
                    .navigationDestination(for: SearchExtendedAlbumsNPM.self) { npm in
                        SearchExtendedAlbums(albums: npm.albums)
                    }
                    
                    .navigationDestination(for: PlaylistContentNPM.self) { npm in
                        PlaylistContent(playlist: npm.playlist)
                    }
                    .navigationDestination(for: SearchArtistExtendedTracksNPM.self) { npm in
                        SearchArtistExtendedTracks(tracks: npm.tracks, artistName: npm.artistName)
                    }
                    .navigationDestination(for: SearchArtistExtendedAlbumsNPM.self) { npm in
                        SearchArtistExtendedAlbums(albums: npm.albums, artistName: npm.artistName)
                    }
                    .navigationDestination(for: SearchArtistExtendedSinglesNPM.self) { npm in
                        SearchArtistExtendedSingles(albums: npm.albums, artistName: npm.artistName)
                    }
                    .navigationDestination(for: LibraryArtistExtendedAlbumsNPM.self) { npm in
                        LibraryArtistExtendedAlbums(albums: npm.albums, artistName: npm.artistName)
                    }
            }
            MiniPlayer(passedNSPath: $searchNSPath)
        }
    }
    private func resetTimers() {
        qsTimer?.invalidate()
        rsTimer?.invalidate()
        qsTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            runQuickSearch()
        }
        rsTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            add_recent()
        }
    }
    func runQuickSearch() {
        if (searchField.count > 3 && viewModel.lastSearch != searchField) {
            quickViewModel.runSearch(query: searchField)
            withAnimation {
                self.viewModel.searchHasChanged = true
            }
        }
    }
    func add_recent() {
        self.recentSearches = add_to_recents(base: recentSearches, add: searchField)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
}

func add_to_recents(base: String, add: String) -> String {
    if (base == "") {
        return add
    } else if (add == "") {
        return base
    }else {
        var recents: [String] = parse_recents(recents: base)
        remove_from_recents(recents: &recents, toRemove: add)
        let newbase: String = recents.suffix(4).joined(separator: "<!SPLITRECENTS!>")
        if newbase == "" {
            return add
        }
        return "\(newbase)<!SPLITRECENTS!>\(add)"
    }
}
func parse_recents(recents: String) -> [String] {
    return recents.components(separatedBy: "<!SPLITRECENTS!>")
}
func remove_from_recents(recents: inout [String], toRemove: String) {
    recents.removeAll(where: {$0 == toRemove})
}


#Preview {
    SearchPage(searchNSPath: .constant(NavigationPath()))
}
