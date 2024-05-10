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
    var body: some View {
        if (downloadManager.are_playbacks_downloaded(PlaybackIDs: album.Tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!})) {
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
                    downloadManager.add_download_task(track: track, explicit: track.Playback_Explicit != nil)
                }
            }) {
                Image(systemName: "arrow.down.circle")
            }
        }
    }
}

//#Preview {
//    //LibraryAlbumDownloadButton()
//}
