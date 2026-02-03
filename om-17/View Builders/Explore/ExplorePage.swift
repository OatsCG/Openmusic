//
//  ExplorePage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI
import SwiftData

struct ExplorePage: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(OMUser.self) var omUser
    @State var viewModel: ExploreViewModel = ExploreViewModel()
    @State var vibesViewModel: VibesViewModel = VibesViewModel()
    @Binding var exploreNSPath: NavigationPath
    @State var hasFirstLoaded: Bool = false
    @State var showingServerSheet: Bool = false
    @State var exploreType: ExploreType = .none
    
    var body: some View {
        ZStack {
            NavigationStack(path: $exploreNSPath) {
                ScrollView {
                    if viewModel.exploreResults == nil {
                        ExploreEmptyPage(viewModel: $viewModel, vibesViewModel: $vibesViewModel, showingServerSheet: $showingServerSheet, hasFirstLoaded: $hasFirstLoaded, exploreType: $exploreType)
                            .onAppear {
                                Task {
                                    await refresh()
                                }
                            }
                            .onChange(of: showingServerSheet) {
                                Task {
                                    await refresh()
                                }
                            }
                    } else {
                        VStack(spacing: 20) {
                            if NetworkManager.shared.networkService.supportedFeatures.contains(.vibes) {
                                ExploreVibesView(vibesViewModel: $vibesViewModel)
                                Divider()
                            }
                            if NetworkManager.shared.networkService.supportedFeatures.contains(.exploreall) {
                                switch exploreType {
                                case .none:
                                    ExploreDefaultView(viewModel: $viewModel)
                                default:
                                    SearchExtendedAlbums(albums: [], type: exploreType)
                                }
                            } else {
                                ExploreDefaultView(viewModel: $viewModel)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .refreshable {
                    await refresh()
                }
                .onChange(of: exploreType) { oldValue, newValue in
                    Task {
                        await refresh()
                    }
                }
                .navigationTitle("Explore")
                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        NavigationLink(value: OMUserNPM()) {
//                            HStack {
//                                Text(omUser.userName)
//                                    .customFont(FontManager.shared, .body, bold: true)
//                                Image(systemName: "person.circle.fill")
//                                    .symbolRenderingMode(.hierarchical)
//                                    .font(.title2)
//                            }
//                        }
//                    }
                }
                .navigationBarTitleDisplayMode(.automatic)
                .safeAreaPadding(.bottom, 80)
                .safeAreaPadding(.top, 20)
                .background {
                    GlobalBackground_component()
                }
                .containerRelativeFrame(.horizontal)
                .sheet(isPresented: $showingServerSheet, content: {
                    AddServerSheet(showingServerSheet: $showingServerSheet)
                })
                .navigationDestination(for: OMUserNPM.self) { npm in
                    UserView()
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
                    SearchExtendedAlbums(albums: npm.albums, type: npm.type)
                }
                .navigationDestination(for: SearchExtendedArtistsNPM.self) { npm in
                    SearchExtendedArtists(artists: npm.artists)
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
                .navigationDestination(for: UserViewNPM.self) { npm in
                    UserView()
                }
            }
        }
    }
    
    func refresh() async {
        viewModel.runSearch(exploreType)
        vibesViewModel.runSearch()
        withAnimation {
            hasFirstLoaded = true
        }
    }
}

enum ExploreType: String, CaseIterable, Identifiable, Codable {
    case random = "Random",
         newest = "Recently Added",
         highest = "Popular",
         frequent = "Frequently Played",
         recent = "Recently Played",
         alphabeticalByName = "Sorted Alphabetically",
         alphabeticalByArtist = "Sorted by Artist",
         none = "Browse"
    var id: Self { self }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Previewable @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ContentView()
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
//            globalIPAddress = "server.openmusic.app"
        }
}
