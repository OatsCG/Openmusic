//
//  BrowsePage.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-02-03.
//

import SwiftUI

struct BrowsePage: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(OMUser.self) var omUser
    @Binding var browseNSPath: NavigationPath
    @State var hasFirstLoaded: Bool = false
    @State var showingServerSheet: Bool = false
    @State var exploreType: ExploreType = .alphabeticalByName
    
    var body: some View {
        ZStack {
            NavigationStack(path: $browseNSPath) {
                BrowseExtendedAlbums(albums: [], type: $exploreType, fetchedPages: [])
                .frame(width: UIScreen.main.bounds.width)
                .navigationTitle("Browse")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if NetworkManager.shared.networkService.supportedFeatures.contains(.exploreall) {
                            Menu {
                                ForEach(ExploreType.allCases, id: \.id) { type in
                                    Button(action: {
                                        if exploreType == type {
                                            exploreType = type
                                        } else {
                                            exploreType = type
                                        }
                                    }) {
                                        Label(type.rawValue, systemImage: exploreType == type ? "checkmark" : "")
                                    }
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                        }
                    }
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
}
