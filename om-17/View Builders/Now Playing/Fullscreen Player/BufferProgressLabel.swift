//
//  BufferProgressLabel.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-12.
//

import SwiftUI

enum DebuggerState {
    case hidden, noconnection, fetcherror, emptyplayback, playererror
}

struct BufferProgressLabel: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var visibleState: DebuggerState
    var body: some View {
        HStack(alignment: .center) {
            if networkMonitor.isConnected == false {
                Image(systemName: "network.slash")
                Text("No Connection")
                    .task {
                        visibleState = .noconnection
                    }
            } else { // if network connected
                if playerManager.currentQueueItem?.currentlyPriming == true {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        Image(systemName: "circle.dashed")
                        Text("Fetching Playback...")
                            .task {
                                visibleState = .hidden
                            }
                    } else {
                        // priming is true, playback exists
                        Image(systemName: "circle.dashed")
                        Text("Buffering...")
                            .task {
                                visibleState = .hidden
                            }
                    }
                } else {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        if playerManager.currentQueueItem?.audio_AVPlayer?.isRemote == false {
                            Image(systemName: "checkmark")
                            Text("Playback Downloaded")
                                .task {
                                    visibleState = .hidden
                                }
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Error Fetching Playback")
                                .task {
                                    visibleState = .fetcherror
                                }
                        }
                    } else {
                        // priming is done, playback exists
                        if (playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL == "") {
                            Image(systemName: "x.circle.fill")
                            VStack(alignment: .leading) {
                                Text("Playback Empty")
                                Text("**YouTube ID**: \(playerManager.currentQueueItem?.fetchedPlayback?.YT_Audio_ID ?? "nil")")
                                Text("**Fetched URL**: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                            }
                            .task {
                                visibleState = .emptyplayback
                            }
                        } else {
                            if playerManager.currentQueueItem?.audio_AVPlayer?.isReady == true {
                                if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .readyToPlay) {
                                    Image(systemName: "checkmark")
                                    Text("Ready")
                                        .task {
                                            visibleState = .hidden
                                        }
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .failed) {
                                    Image(systemName: "x.circle.fill")
                                    Text("Failed")
                                        .task {
                                            visibleState = .playererror
                                        }
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .unknown) {
                                    Image(systemName: "circle.dashed")
                                    Text("Waiting")
                                        .task {
                                            visibleState = .hidden
                                        }
                                } else {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text("Unknown")
                                        .task {
                                            visibleState = .hidden
                                        }
                                }
                            } else {
                                if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .readyToPlay) {
                                    // PLAYER GETS STUCK HERE
                                    if let p = playerManager.currentQueueItem?.audio_AVPlayer?.player as? AEPlayerOnline  {
                                        if p.player.currentItem == nil {
                                            // no item loaded
                                            Text("player.currentItem not loaded")
                                        } else {
                                            if p.player.status == .failed {
                                                Text("Failed 3")
                                            } else if p.player.status == .readyToPlay {
                                                if playerManager.currentQueueItem?.currentlyPriming == true {
                                                    Text("Currently Priming...")
                                                } else {
                                                    Text("ReadyToPlay 3, Not Priming")
                                                }
                                            } else {
                                                Text("Unknown 3")
                                            }
                                        }
                                    } else {
                                        Text("Player Offline")
                                    }
                                    
//                                    Image(systemName: "exclamationmark.triangle.fill")
//                                    Text("Initializing Buffer...")
//                                    Text("url: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
//                                        .task {
//                                            visibleState = .hidden
//                                        }
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .failed) {
                                    Image(systemName: "x.circle.fill")
                                    Text("Failed 2")
                                        .task {
                                            visibleState = .hidden
                                        }
                                } else if (playerManager.currentQueueItem?.audio_AVPlayer?.player.status == .unknown) {
                                    Image(systemName: "circle.dashed")
                                    Text("Waiting 2")
                                        .task {
                                            visibleState = .hidden
                                        }
                                } else {
                                    if (playerManager.currentQueueItem?.audio_AVPlayer == nil) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        VStack {
                                            Text("Audio Uninitialized")
                                            Text("url: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                                        }
                                        .task {
                                            visibleState = .hidden
                                        }
                                    } else {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("Unknown 2")
                                            .task {
                                                visibleState = .hidden
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
}
