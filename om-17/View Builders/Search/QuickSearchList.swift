//
//  QuickSearchList.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI
import SwiftData

struct QuickSearchList: View {
    @SceneStorage("recentSearches") var recentSearches: String = ""
    @Binding var viewModel: SearchViewModel
    @Binding var quickViewModel: QuickSearchViewModel
    @Binding var searchField: String
    var body: some View {
        VStack {
            //Divider()
//            if quickViewModel.attenptingSearch {
//                LoadingTracklist_component()
//            }
            if quickViewModel.fetchedTracks == nil && quickViewModel.SearchInitialized {
                LoadingBigTracks_component()
                    .safeAreaPadding(.horizontal, 10)
                //LoadingTracklist_component()
//                Spacer()
//                ContentUnavailableView {
//                    Label("No connection to server", systemImage: "wifi.exclamationmark")
//                } description: {
//                    Text("Check your connection and try again.")
//                }
//                Spacer()
            } else if (quickViewModel.fetchedTracks?.Tracks.count == 0) {
                Spacer()
                ContentUnavailableView {
                    Label("", systemImage: "magnifyingglass")
                } description: {
                    Text("Quick search for \(searchField) will appear here.")
                }
                Spacer()
            } else {
                VStack(spacing: 20) {
                    Button(action: {
                        add_recent()
                        viewModel.runSearch(query: searchField)
                        self.hideKeyboard()
                    }) {
                        AlbumWideButton_component(text: "More Results...", ArtworkID: "")
                        .padding(.horizontal, 100)
                    }
                    SearchExtendedTracks(tracks: quickViewModel.fetchedTracks?.Tracks, shouldQueueAll: false)
                }
            }
        }
    }
    func add_recent() {
        self.recentSearches = add_to_recents(base: recentSearches, add: searchField)
    }
}


#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return SearchPage(searchNSPath: .constant(NavigationPath()), selectionBinding: .constant(1))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
            globalIPAddress = "https://openmusic.app"
        }
}
