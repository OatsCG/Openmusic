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
    @State var tracksDownloaded: Bool = false
    @State var tracksDownloading: Bool = false
    
    var body: some View {
        Group {
            if tracksDownloaded {
                Menu {
                    Button(role: .destructive, action: {
                        for track in tracks {
                            if let Playback_Clean = track.Playback_Clean {
                                downloadManager.delete_playback(PlaybackID: Playback_Clean)
                            }
                            if let Playback_Explicit = track.Playback_Explicit {
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
            } else if tracksDownloading {
                Image(systemName: "circle.dashed")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title3)
            } else {
                Button (action: {
                    for track in tracks {
                        downloadManager.addDownloadTask(track: track, explicit: track.Playback_Explicit != nil)
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
                await updateTracksDownloaded(tracks: tracks)
            }
        }
        .onChange(of: downloadManager.sumProgression) {
            Task {
                await are_tracks_downloading(tracks: tracks)
            }
        }
    }
    
    private func updateTracksDownloaded(tracks: [any Track]) async {
        var preferredPlaybacks: [String] = []
        for track in tracks {
            if let Playback_Explicit = track.Playback_Explicit {
                preferredPlaybacks.append(Playback_Explicit)
            } else if let Playback_Clean = track.Playback_Clean {
                preferredPlaybacks.append(Playback_Clean)
            }
        }
        tracksDownloaded = await downloadManager.are_playbacks_downloaded(PlaybackIDs: preferredPlaybacks)
        
    }
    
    private func are_tracks_downloading(tracks: [any Track]) async {
        var preferredPlaybacks: [String] = []
        for track in tracks {
            if let Playback_Explicit = track.Playback_Explicit {
                preferredPlaybacks.append(Playback_Explicit)
            } else if let Playback_Clean = track.Playback_Clean {
                preferredPlaybacks.append(Playback_Clean)
            }
        }
        for playback in preferredPlaybacks {
            if await downloadManager.task_exists(PlaybackID: playback) {
                tracksDownloading = true
                return
            }
        }
        tracksDownloading = false
    }
}
