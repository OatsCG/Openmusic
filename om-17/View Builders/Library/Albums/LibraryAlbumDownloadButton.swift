//
//  LibraryAlbumDownloadButton.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-20.
//

import SwiftUI

struct LibraryAlbumDownloadButton: View {
    @Environment(DownloadManager.self) var downloadManager
    var album: StoredAlbum
    @State var arePlaybacksDownloaded: Bool = false
    var body: some View {
        if arePlaybacksDownloaded {
            Menu {
                Button(role: .destructive, action: {
                    for track in album.Tracks {
                        if track.Playback_Clean != nil {
                            downloadManager.delete_playback(PlaybackID: track.Playback_Clean!)
                        }
                        if track.Playback_Explicit != nil {
                            downloadManager.delete_playback(PlaybackID: track.Playback_Explicit!)
                        }
                    }
                }) {
                    Label("Remove Downloads", systemImage: "trash")
                }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
        } else {
            Button (action: {
                for track in (album.Tracks) {
                    downloadManager.addDownloadTask(track: track, explicit: track.Playback_Explicit != nil)
                }
            }) {
                Image(systemName: "arrow.down.circle")
            }
            .onAppear {
                Task {
                    await updatePlaybacksDownloaded()
                }
            }
        }
    }
    func updatePlaybacksDownloaded() async {
        arePlaybacksDownloaded = await downloadManager.are_playbacks_downloaded(PlaybackIDs: album.Tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!})
    }
}

//#Preview {
//    //LibraryAlbumDownloadButton()
//}
