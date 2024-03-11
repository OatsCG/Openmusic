//
//  SearchResultsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct SearchResultsView: View {
    @Environment(\.isSearching) private var isSearching
    @AppStorage("recentlyPlayed") var recentlyPlayed: String = ""
    @Binding var viewModel: SearchViewModel
    @Binding var quickViewModel: QuickSearchViewModel
    @Binding var searchField: String
    var body: some View {
        ScrollView {
            if (searchField == "") {
                VStack(alignment: .leading, spacing: 20) {
                    RecentSearchesList(viewModel: $viewModel, searchField: $searchField)
                    if (recentlyPlayed != "") {
                        RecentlyPlayedList()
                            .padding(.top, 10)
                    }
                }
            } else if (viewModel.fullSearchSubmitted == false) {
                QuickSearchList(viewModel: $viewModel, quickViewModel: $quickViewModel, searchField: $searchField)
            } else { // after a submit
                if viewModel.attenptingSearch {
                    LoadingSearchResults_component()
                } else if viewModel.searchResults == nil {
                    Spacer()
                    ContentUnavailableView {
                        Label("No connection", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text("Check your server connection, or add a server in Options.")
                    }
                    Spacer()
                } else if ((viewModel.searchResults!.Tracks.count + viewModel.searchResults!.Albums.count + viewModel.searchResults!.Singles.count + viewModel.searchResults!.Artists.count) == 0) {
                    Spacer()
                    ContentUnavailableView.search(text: viewModel.lastSearch)
                    Spacer()
                } else {
                    VStack(spacing: 20) {
                        SearchShelfTracks(tracks: viewModel.searchResults?.Tracks)
                        Divider()
                        SearchShelfAlbums(viewModel: viewModel)
                        Divider()
                        SearchShelfSingles(viewModel: viewModel)
                        Divider()
                        SearchShelfArtists(viewModel: viewModel)
                    }
                }
            }
        }
            .safeAreaPadding(.bottom, 80)
    }
}


#Preview {
    ExplorePage(exploreNSPath: .constant(NavigationPath()))
}


