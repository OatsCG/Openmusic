//
//  LibraryAlbumHeader.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-29.
//

import SwiftUI

struct LibraryAlbumHeader: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @State var album: StoredAlbum
    
    var body: some View {
        VStack {
            AlbumContentHeading_component(album: SearchedAlbum(from: album), tracks: album.Tracks)
            Divider()
        }
    }
}
