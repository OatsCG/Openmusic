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
    @State var showingServerSheet: Bool = false
    
    var body: some View {
        ScrollView {
            Group {
                if searchField == "" {
                    VStack(alignment: .leading, spacing: 20) {
                        RecentSearchesList(viewModel: $viewModel, searchField: $searchField)
                        if (recentlyPlayed != "") {
                            RecentlyPlayedList()
                                .padding(.top, 10)
                        }
                    }
                } else if !viewModel.fullSearchSubmitted {
                    QuickSearchList(viewModel: $viewModel, quickViewModel: $quickViewModel, searchField: $searchField)
                } else { // after a submit
                    if viewModel.attemptingSearch {
                        LoadingSearchResults_component()
                    } else if let searchResults = viewModel.searchResults {
                        if searchResults.Tracks.isEmpty && searchResults.Albums.isEmpty && searchResults.Singles.isEmpty && searchResults.Artists.isEmpty {
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
                    } else {
                        Spacer()
                        if NetworkManager.globalIPAddress() != "" {
                            ContentUnavailableView {
                                Label("No connection", systemImage: "wifi.exclamationmark")
                            } description: {
                                Text("Check your server connection in Options.")
                            }
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Image(systemName: "network.slash")
                                        .font(.largeTitle)
                                        .scaleEffect(1.35)
                                        .foregroundStyle(.secondary)
                                        .padding(.bottom, 10)
                                    Text("No Server Added")
                                        .font(.title2.bold())
                                        .multilineTextAlignment(.center)
                                    Text("Openmusic streams from custom servers.\nAdd a server to get started.")
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                    Button(action: {
                                        showingServerSheet.toggle()
                                    }) {
                                        AlbumWideButton_component(text: "Add a Server", ArtworkID: "")
                                            .frame(width: 200)
                                    }
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                }
            }
            .padding(.top, 1)
        }
            .safeAreaPadding(.bottom, 80)
            .sheet(isPresented: $showingServerSheet, content: {
                AddServerSheet(showingServerSheet: $showingServerSheet)
            })
            .onChange(of: showingServerSheet) {
                viewModel.runLastSearch()
            }
    }
}

#Preview {
    ExplorePage(exploreNSPath: .constant(NavigationPath()))
}
