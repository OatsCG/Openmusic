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
    @State var viewModel: ExploreViewModel = ExploreViewModel()
    @Binding var exploreNSPath: NavigationPath
    @State var hasFirstLoaded: Bool = false
    @State var showingServerSheet: Bool = false
    var body: some View {
        ZStack {
            NavigationStack(path: $exploreNSPath) {
                ScrollView {
//                    HStack {
//                        Text("Explore")
//                            .font(.largeTitle .bold())
//                        Spacer()
//                        NavigationLink(value: UserViewNPM()) {
//                            Image(systemName: "person.circle.fill")
//                                .symbolRenderingMode(.hierarchical)
//                                .font(.largeTitle)
//                        }
//                        .buttonStyle(.plain)
//                    }
//                        .padding()

                    
                    if viewModel.exploreResults == nil {
                        Group {
                            if (viewModel.isSearching == true || self.hasFirstLoaded == false) {
                                LoadingExplore_component()
                            } else {
                                VStack {
                                    Spacer()
                                    if (globalIPAddress() != "") {
                                        ContentUnavailableView {
                                            Label("No Connection", systemImage: "wifi.exclamationmark")
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
                            .onAppear {
                                viewModel.runSearch()
                                withAnimation {
                                    self.hasFirstLoaded = true
                                }
                            }
                            .onChange(of: showingServerSheet) {
                                viewModel.runSearch()
                                withAnimation {
                                    self.hasFirstLoaded = true
                                }
                            }
                    } else {
                        VStack(spacing: 20) {
                            ExploreShelfBigView(exploreShelf: viewModel.exploreResults!.Shelves.first!)
                            Divider()
                                .padding(.bottom, 15)
                            ForEach(viewModel.exploreResults!.Shelves.dropFirst(), id: \.self) { shelf in
                                ExploreShelfView(exploreShelf: shelf)
                                Divider()
                                    .padding(.bottom, 15)
                            }
                        }
                            //.transition(.blurReplace)
                        
                        Button(action: {
                            Task.detached {
                                playRandomSongs { (result) in
                                    switch result {
                                    case .success(let data):
                                        withAnimation {
                                            playerManager.fresh_play_multiple(tracks: data.Tracks)
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                            }
                        }) {
                            Text("I'm Feeling Lucky")
                                .padding(10)
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .refreshable {
                    viewModel.runSearch()
                }
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.automatic)
                .safeAreaPadding(.bottom, 80)
                .safeAreaPadding(.top, 20)
                .background {
                    GlobalBackground_component()
                }
                .sheet(isPresented: $showingServerSheet, content: {
                    AddServerSheet(showingServerSheet: $showingServerSheet)
                })
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
                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Image(systemName: "person.circle.fill")
//                            .symbolRenderingMode(.hierarchical)
//                            .font(.title2)
//                    }
                }
            }
            MiniPlayer( passedNSPath: $exploreNSPath)
        }
    }
}


/*
 
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
 */



#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
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
            globalIPAddress = "server.openmusic.app"
        }
}

