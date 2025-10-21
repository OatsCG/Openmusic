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
                            if let Playback_Clean = item.track.Playback_Clean {
                                downloadManager.delete_playback(PlaybackID: Playback_Clean)
                            }
                            if let Playback_Explicit = item.track.Playback_Explicit {
                                downloadManager.delete_playback(PlaybackID: Playback_Explicit)
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
        var playbackIDs: [String] = []
        for item in playlist.items.filter({ $0.importData.status == .success }) {
            if let Playback_Explicit = item.track.Playback_Explicit {
                playbackIDs.append(Playback_Explicit)
            }
            if let Playback_Clean = item.track.Playback_Clean {
                playbackIDs.append(Playback_Clean)
            }
        }
        return await downloadManager.are_playbacks_downloaded(PlaybackIDs: playbackIDs)
    }
}
