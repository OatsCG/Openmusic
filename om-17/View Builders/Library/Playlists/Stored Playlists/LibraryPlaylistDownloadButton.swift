//
//  LibraryPlaylistDownloadButton.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-06.
//

import SwiftUI

struct LibraryPlaylistDownloadButton: View {
    @Environment(DownloadManager.self) var downloadManager
    var playlist: StoredPlaylist
    @State var playbacksDownloaded: Bool = false
    var body: some View {
        Group {
            if playbacksDownloaded {
                Menu {
                    Button(role: .destructive, action: {
                        for item in playlist.items {
                            if item.track.Playback_Clean != nil {
                                downloadManager.delete_playback(PlaybackID: item.track.Playback_Clean!)
                            }
                            if item.track.Playback_Explicit != nil {
                                downloadManager.delete_playback(PlaybackID: item.track.Playback_Explicit!)
                            }
                        }
                    }) {
                        Label("Remove Downloads", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title3)
                }
            } else {
                Button (action: {
                    for item in playlist.items {
                        if item.importData.status == .success {
                            downloadManager.addDownloadTask(track: item.track, explicit: item.explicit)
                        }
                    }
                }) {
                    Image(systemName: "arrow.down.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title3)
                }
            }
        }
        .onAppear {
            Task {
                await updatePlaybacksDownloaded()
            }
        }
    }
    
    func updatePlaybacksDownloaded() async -> Bool {
        let playbackIDs = playlist.items.filter({ $0.importData.status == .success }).map{$0.track}.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!}
        return await downloadManager.are_playbacks_downloaded(PlaybackIDs: playbackIDs)
    }
}
