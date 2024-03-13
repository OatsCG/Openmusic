//
//  BufferProgressLabel.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-12.
//

import SwiftUI

struct BufferProgressLabel: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    var body: some View {
        HStack(alignment: .center) {
            if networkMonitor.isConnected == false {
                Image(systemName: "network.slash")
                Text("No connection")
            } else { // if network connected
                if playerManager.currentQueueItem?.currentlyPriming == true {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        Image(systemName: "circle.dashed")
                        Text("Fetching playback...")
                    } else {
                        // priming is true, playback exists
                        Image(systemName: "circle.dashed")
                        Text("Buffering...")
                    }
                } else {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        if playerManager.currentQueueItem?.audio_AVPlayer?.isRemote == false {
                            Image(systemName: "checkmark")
                            Text("Playback downloaded")
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Failed fetching playback")
                        }
                    } else {
                        // priming is done, playback exists
                        if (playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL == "") {
                            Image(systemName: "x.circle.fill")
                            VStack(alignment: .leading) {
                                Text("Playback empty")
                                Text("**YouTube ID**: \(playerManager.currentQueueItem?.fetchedPlayback?.YT_Audio_ID ?? "nil")")
                                Text("**Fetched URL**: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                            }
                        } else {
                            if playerManager.currentQueueItem?.audio_AVPlayer?.isReady == true {
                                if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .readyToPlay) {
                                    Image(systemName: "checkmark")
                                    Text("Player ready")
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .failed) {
                                    Image(systemName: "x.circle.fill")
                                    Text("Player failed")
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .unknown) {
                                    Image(systemName: "circle.dashed")
                                    Text("Player waiting")
                                } else {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text("Player status unknown")
                                }
                            } else {
                                if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .readyToPlay) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text("False ready")
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .failed) {
                                    Image(systemName: "x.circle.fill")
                                    Text("Player failed 2")
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .unknown) {
                                    Image(systemName: "circle.dashed")
                                    Text("Player waiting 2")
                                } else {
                                    if (playerManager.currentQueueItem?.audio_AVPlayer == nil) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        VStack {
                                            Text("Audio uninitialized")
                                            Text("url: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                                        }
                                    } else {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("Player status unknown 2")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BufferProgressLabel()
}
