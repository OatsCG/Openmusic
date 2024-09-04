//
//  BufferProgressLabel.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-12.
//

import SwiftUI
import AVFoundation

enum DebuggerState {
    case hidden, noconnection, fetcherror, emptyplayback, playererror, fetching, buffering
}

struct BufferProgressLabel: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var visibleState: DebuggerState
    @State var currentPlayerStatus: AVPlayer.Status? = nil
    @State var currentPlayerDuration: Double? = nil
    var body: some View {
        HStack(alignment: .center) {
            if networkMonitor.isConnected == false && playerManager.currentQueueItem?.isDownloaded == false {
                Image(systemName: "network.slash")
                Text("No Connection")
                    .task {
                        withAnimation {
                            visibleState = .noconnection
                        }
                    }
            } else { // if network connected
                if playerManager.currentQueueItem?.currentlyPriming == true {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        Image(systemName: "circle.dashed")
                        Text("Fetching Playback...")
                            .task {
                                withAnimation {
                                    visibleState = .fetching
                                }
                            }
                    } else {
                        // priming is true, playback exists
                        Image(systemName: "circle.dashed")
                        Text("Buffering...")
                            .task {
                                withAnimation {
                                    visibleState = .buffering
                                }
                            }
                    }
                } else {
                    if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        if playerManager.currentQueueItem?.isDownloaded == true {
                            Image(systemName: "checkmark")
                            Text("Playback Downloaded")
                                .task {
                                    withAnimation {
                                        visibleState = .hidden
                                    }
                                }
                        } else {
                            if playerManager.currentQueueItem == nil {
                                Image(systemName: "x.circle.fill")
                                Text("Not Playing")
                                    .task {
                                        withAnimation {
                                            visibleState = .hidden
                                        }
                                    }
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Error Fetching Playback")
                                    .task {
                                        withAnimation {
                                            visibleState = .fetcherror
                                        }
                                    }
                            }
                        }
                    } else {
                        // priming is done, playback exists
                        BufferLabelLevelTwo(visibleState: $visibleState, currentPlayerStatus: $currentPlayerStatus, currentPlayerDuration: $currentPlayerDuration)
                    }
                }
            }
        }
            .onChange(of: playerManager.currentQueueItem?.status) { oldValue, newValue in
                Task {
                    currentPlayerStatus = newValue
                }
            }
            .onChange(of: playerManager.currentQueueItem?.duration) { oldValue, newValue in
                Task {
                    currentPlayerDuration = newValue
                }
            }
    }
}


struct BufferLabelLevelTwo: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var visibleState: DebuggerState
    @Binding var currentPlayerStatus: AVPlayer.Status?
    @Binding var currentPlayerDuration: Double?
    @State var onlinePlayer: AEPlayerOnline?
    var body: some View {
        Group {
            if (playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL == "") {
                Image(systemName: "x.circle.fill")
                VStack(alignment: .leading) {
                    /*
                     Happens when
                     
                     PREREQS
                     networkMonitor.isConnected == true
                     playerManager.currentQueueItem?.currentlyPriming == false
                     playerManager.currentQueueItem?.fetchedPlayback != nil
                     playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL == ""
                     
                     - connected to wifi
                     - not currently priming
                     - playback exists
                     - playback URL == ""
                     
                     */
                    Text("Not Available For Streaming")
                    Text("**YouTube ID**: \(playerManager.currentQueueItem?.fetchedPlayback?.YT_Audio_ID ?? "nil")")
                    Text("**Fetched URL**: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                }
                .task {
                    withAnimation {
                        visibleState = .emptyplayback
                    }
                }
            } else {
                if playerManager.currentQueueItem?.isReady == true {
                    if (self.currentPlayerStatus == .readyToPlay) {
                        if (self.currentPlayerDuration ?? 0 > 0) {
                            Image(systemName: "checkmark")
                            Text("Ready")
                                .task {
                                    withAnimation {
                                        visibleState = .hidden
                                    }
                                }
                        } else {
                            ProgressView()
                                .progressViewStyle(.circular)
                            Text("Buffering")
                                .task {
                                    withAnimation {
                                        visibleState = .buffering
                                    }
                                }
                        }
                        
                    } else if (self.currentPlayerStatus == .failed) {
                        Image(systemName: "x.circle.fill")
                        Text("Failed")
                            .task {
                                withAnimation {
                                    visibleState = .playererror
                                }
                            }
                    } else if (self.currentPlayerStatus == .unknown) {
                        Image(systemName: "circle.dashed")
                        Text("Waiting")
                            .task {
                                withAnimation {
                                    visibleState = .buffering
                                }
                            }
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Unknown")
                            .task {
                                withAnimation {
                                    visibleState = .buffering
                                }
                            }
                    }
                } else {
                    BufferLabelLevelThree(visibleState: $visibleState, currentPlayerStatus: $currentPlayerStatus, currentPlayerDuration: $currentPlayerDuration, onlinePlayer: $onlinePlayer)
                }
            }
        }
        .onChange(of: playerManager.currentQueueItem?.status) { oldValue, newValue in
            Task {
                let onlinePlayer = await playerManager.currentQueueItem?.getAudioAVPlayer()?.player as? AEPlayerOnline
                await MainActor.run {
                    self.onlinePlayer = onlinePlayer
                }
            }
        }
    }
}


struct BufferLabelLevelThree: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var visibleState: DebuggerState
    @Binding var currentPlayerStatus: AVPlayer.Status?
    @Binding var currentPlayerDuration: Double?
    @Binding var onlinePlayer: AEPlayerOnline?
    
    var body: some View {
        Group {
            if (self.currentPlayerStatus == .readyToPlay) {
                // PLAYER GETS STUCK HERE
                if let p = self.onlinePlayer {
                    if p.player.currentItem == nil {
                        // no item loaded
                        Text("player.currentItem not loaded")
                            .task {
                                withAnimation {
                                    visibleState = .playererror
                                }
                            }
                    } else {
                        if p.player.status == .failed {
                            Text("Failed 3")
                                .task {
                                    withAnimation {
                                        visibleState = .playererror
                                    }
                                }
                        } else if p.player.status == .readyToPlay {
                            if playerManager.currentQueueItem?.currentlyPriming == true {
                                Text("Currently Priming...")
                                    .task {
                                        withAnimation {
                                            visibleState = .buffering
                                        }
                                    }
                            } else {
                                Text("ReadyToPlay 3, Not Priming. Buffering...")
                                    .task {
                                        withAnimation {
                                            visibleState = .buffering
                                        }
                                    }
                            }
                        } else {
                            Text("Unknown 3")
                                .task {
                                    withAnimation {
                                        visibleState = .playererror
                                    }
                                }
                        }
                    }
                } else {
                    Text("Player Offline")
                        .task {
                            withAnimation {
                                visibleState = .hidden
                            }
                        }
                }
            } else if (self.currentPlayerStatus == .failed) {
                Image(systemName: "x.circle.fill")
                Text("Failed 2")
                    .task {
                        withAnimation {
                            visibleState = .playererror
                        }
                    }
            } else if (self.currentPlayerStatus == .unknown) {
                Image(systemName: "circle.dashed")
                Text("Waiting 2")
                    .task {
                        withAnimation {
                            visibleState = .buffering
                        }
                    }
            } else {
                if (playerManager.currentQueueItem?.isReady == false) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    VStack {
                        Text("Audio Uninitialized")
                        Text("url: \(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")")
                    }
                    .task {
                        withAnimation {
                            visibleState = .playererror
                        }
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Unknown 2")
                        .task {
                            withAnimation {
                                visibleState = .playererror
                            }
                        }
                }
            }
        }
    }
}
