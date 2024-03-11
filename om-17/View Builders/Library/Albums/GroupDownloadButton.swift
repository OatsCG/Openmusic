//
//  GroupDownloadButton.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct GroupDownloadButton: View {
    @Environment(DownloadManager.self) var downloadManager
    var tracks: [any Track]
    var body: some View {
        if (tracks_downloaded(tracks: tracks)) {
            Menu {
                Button(role: .destructive, action: {
                    for track in tracks {
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
                    .font(.title3)
            }
        } else if (are_tracks_downloading(tracks: tracks)) {
            Image(systemName: "circle.dashed")
                .symbolRenderingMode(.hierarchical)
                .font(.title3)
        } else {
            Button (action: {
                for track in tracks {
                    downloadManager.start_download(track: track, explicit: track.Playback_Explicit != nil)
                }
            }) {
                Image(systemName: "arrow.down.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title3)
            }
        }
    }
    
    private func tracks_downloaded(tracks: [any Track]) -> Bool {
        let preferredPlaybacks: [String] = tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!}
        return downloadManager.are_playbacks_downloaded(PlaybackIDs: preferredPlaybacks)
    }
    
    private func are_tracks_downloading(tracks: [any Track]) -> Bool {
        let preferredPlaybacks: [String] = tracks.map{$0.Playback_Explicit != nil ? $0.Playback_Explicit! : $0.Playback_Clean!}
        for playback in preferredPlaybacks {
            if downloadManager.task_exists(PlaybackID: playback) {
                return true
            }
        }
        return false
    }
//    
//    private func tracks_progress(tracks: [Track]) -> Double {
//        var sumProgression: Double = 0
//        var trackCount: Double = 0
//        for track in tracks {
//            let playbackID: Int = track.Playback_Explicit ?? track.Playback_Clean!
//            if downloadManager.task_exists(PlaybackID: playbackID) {
//                let task: DownloadData? = downloadManager.find_download_data(PlaybackID: playbackID)
//                sumProgression += task?.progress ?? 0
//                trackCount += 1
//            }
//        }
//        if trackCount == 0 {
//            return 0
//        }
//        return (sumProgression / trackCount)
//    }
    
}

