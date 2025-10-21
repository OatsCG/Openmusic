//
//  RecentAlbum.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-30.
//

import SwiftUI
import SwiftData

struct QuickplayItem: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var tracks: [StoredTrack]
    
    var body: some View {
        if tracks.count == 1 {
            QPMultipleLink_component(tracks: tracks)
                .aspectRatio(CGFloat(QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fill)
        } else {
            QPMultipleLink_component(tracks: tracks)
                .aspectRatio(CGFloat(QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fill)
        }
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    let track = StoredTrack(from: FetchedTrack(default: true))
    
    return ScrollView {
        VStackWrapped(columns: 1) {
            QuickplayItem(tracks: [track, track])
            QuickplayItem(tracks: [track])
            QuickplayItem(tracks: [track, track])
        }
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
        }
}
