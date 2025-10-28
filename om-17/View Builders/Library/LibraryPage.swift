//
//  LibraryPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-06.
//

import SwiftUI
import SwiftData

struct LibraryPage: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(BackgroundDatabase.self) private var database
    @State var selectedPick: LibraryPicks = .recents
    @Binding var libraryNSPath: NavigationPath
    @State var tracks: [StoredTrack] = []
    @State var playlists: [StoredPlaylist]? = nil
    
    var body: some View {
        ZStack {
            NavigationStack(path: $libraryNSPath) {
                ScrollView {
                    VStack {
                        LibraryPicker(selectedPick: $selectedPick)
                        LiveDownloadsList()
                        LiveImportingList(playlists: $playlists)
                        switch selectedPick {
                            case .music:
                                LibraryMusicPicker(tracks: $tracks)
                            case .playlists:
                                LibraryPlaylistsList(playlists: $playlists, libraryNSPath: $libraryNSPath)
                            case .recents:
                                LibraryRecentsList(tracks: $tracks)
                        }
                    }
                        .padding(.all, 12)
                        .padding(.top, 1)
                }
                    .navigationTitle(selectedPick.rawValue.capitalized)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(value: FileManagerNPM()) {
                                Image(systemName: "folder.fill.badge.gearshape")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .safeAreaPadding(.bottom, 80)
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
                    .navigationDestination(for: PlaylistEditMenuNPM.self) { npm in
                        PlaylistEditMenu(playlist: npm.playlist, playlistTitle: npm.playlist.Title, playlistBio: npm.playlist.Bio)
                    }
                    .navigationDestination(for: PlaylistReviewTracksNPM.self) { npm in
                        PlaylistReviewTracks(playlist: npm.playlist)
                    }
                    .navigationDestination(for: FileManagerNPM.self) { npm in
                        FileManagerView()
                    }
                    .navigationDestination(for: ManageAudiosNPM.self) { npm in
                        ManageAudios()
                    }
                    .navigationDestination(for: ManageImagesNPM.self) { npm in
                        ManageImages()
                    }
            }
        }
        .onAppear {
            self.updateTracks()
        }
    }
    
    private func updateTracks() {
        Task {
            let predicate = #Predicate<StoredTrack> { _ in true }
            let sortDescriptors = [SortDescriptor(\StoredTrack.dateAdded)]
            let fetchedtracks = try? await database.fetch(predicate, sortBy: sortDescriptors)
            if let fetchedtracks {
                updateTracksWith(fetchedtracks)
            } else {
                updateTracksWith([])
            }
        }
    }
    
    @MainActor
    func updateTracksWith(_ with: [StoredTrack]) {
        tracks = with
    }
}

struct LibraryPicker: View {
    @Binding var selectedPick: LibraryPicks
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Picker("Category", selection: $selectedPick) {
            ForEach(LibraryPicks.allCases) { option in
                Image(systemName: libraryPickSymbol(pick: option))
                    .background {
                        Rectangle().fill(.red)
                    }
            }
        }
            .pickerStyle(.segmented)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    //let playlist = StoredPlaylist(Title: "Test!")
    
    return LibraryPage(libraryNSPath: .constant(NavigationPath()))
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .modelContainer(container)
}
