//
//  QueueMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import SwiftData

struct QueueMenu: View {
    @Environment(DownloadManager.self) var downloadManager
    @Environment(PlayerManager.self) var playerManager
    @Binding var selectedPick: QueuePicks
    var body: some View {
        if selectedPick == .queue {
            Section("Up Next: \(playerManager.trackQueue.filter{$0.explicit == true}.count) Explicit, \(playerManager.trackQueue.filter{$0.explicit == false}.count) Clean") {
                Button(action: {
                    for item in playerManager.trackQueue {
                        downloadManager.start_download(track: StoredTrack(from: item), explicit: item.explicit)
                    }
                }) {
                    Label("Download All", systemImage: "square.and.arrow.down")
                }
                Button(action: {
                    for item in playerManager.trackQueue {
                        if item.Track.Playback_Clean != nil {
                            item.setExplicity(to: false)
                        }
                    }
                    Task {
                        await playerManager.prime_next_song()
                    }
                }) {
                    Label("Try Converting to Clean", systemImage: "c.square")
                }
                Button(action: {
                    for item in playerManager.trackQueue {
                        if item.Track.Playback_Explicit != nil {
                            item.setExplicity(to: true)
                        }
                    }
                    Task {
                        await playerManager.prime_next_song()
                    }
                }) {
                    Label("Try Converting to Explicit", systemImage: "e.square")
                }
            }
            Section {
                Button(role: .destructive, action: {
                    playerManager.reset_up_next()
                }) {
                    Label("Clear Up Next", systemImage: "minus.circle")
                }
            }
        } else {
            Section("Played: \(playerManager.sessionHistory.filter{$0.explicit == true}.count) Explicit, \(playerManager.sessionHistory.filter{$0.explicit == false}.count) Clean") {
                Button(action: {
                    for item in playerManager.sessionHistory {
                        downloadManager.start_download(track: StoredTrack(from: item), explicit: item.explicit)
                    }
                }) {
                    Label("Download All", systemImage: "square.and.arrow.down")
                }
                Button(action: {
                    for item in playerManager.sessionHistory {
                        if item.Track.Playback_Clean != nil {
                            item.setExplicity(to: false)
                        }
                    }
                    Task {
                        await playerManager.prime_next_song()
                    }
                }) {
                    Label("Try Converting to Clean", systemImage: "c.square")
                }
                Button(action: {
                    for item in playerManager.sessionHistory {
                        if item.Track.Playback_Explicit != nil {
                            item.setExplicity(to: true)
                        }
                    }
                    Task {
                        await playerManager.prime_next_song()
                    }
                }) {
                    Label("Try Converting to Explicit", systemImage: "e.square")
                }
            }
            Section {
                Button(role: .destructive, action: {
                    playerManager.reset_session_history()
                }) {
                    Label("Clear History", systemImage: "minus.circle")
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    let playerManager = PlayerManager()
    return Menu("PRESS ME!") {
        QueueMenu(selectedPick: .constant(QueuePicks.queue))
            .modelContainer(container)
            .environment(playerManager)
            .environment(DownloadManager())
    }
}
