//
//  SearchAlbumHeader.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-29.
//

import SwiftUI
import SwiftData

struct SearchAlbumHeader: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @State var album: SearchedAlbum
    @State var albumModel: AlbumViewModel
    var body: some View {
        VStack {
            AlbumContentHeading_component(album: album, tracks: albumModel.fetchedAlbum?.Tracks)
            Divider()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return SearchAlbumContent(album: SearchedAlbum(default: true))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
