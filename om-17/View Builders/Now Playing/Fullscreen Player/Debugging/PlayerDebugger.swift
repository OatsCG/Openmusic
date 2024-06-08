//
//  PlayerDebugg.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-14.
//

import SwiftUI

struct PlayerDebugger: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @AppStorage("playerDebugger") var playerDebugger: Bool = false
    @State var visibleState: DebuggerState = .hidden
    var body: some View {
        if (playerDebugger == true) {
            PlayerDebuggerComplex(visibleState: $visibleState)
        } else {
            ZStack {
                if (playerManager.currentQueueItem?.primeStatus == .loading) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 5) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                        .font(.caption2)
                        .lineLimit(1)
                        .padding(10)
                } else if (playerManager.currentQueueItem?.primeStatus == .success) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 5) {
                                Image(systemName: "circle.dashed")
                                    .font(.body)
                                    .symbolEffect(.pulse, isActive: true)
                                    .foregroundStyle(.secondary)
                            }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                        .font(.caption2)
                        .lineLimit(1)
                        .padding(10)
                } else if (playerManager.currentQueueItem?.primeStatus == .primed) {
                    EmptyView()
                } else if (playerManager.currentQueueItem?.primeStatus == .failed || playerManager.currentQueueItem?.primeStatus == .passed) {
                    if networkMonitor.isConnected == false {
                        PlayerDebuggerSimple(visible: true, text: "No Connection", symbol: "network.slash")
                    } else if playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL == "" {
                        PlayerDebuggerSimple(visible: true, text: "Not Available For Streaming", symbol: "x.circle.fill")
                    } else if playerManager.currentQueueItem?.fetchedPlayback == nil {
                        PlayerDebuggerSimple(visible: true, text: "Error Fetching Playback", symbol: "exclamationmark.triangle.fill")
                    } else {
                        PlayerDebuggerSimple(visible: true, text: "Player Failed", symbol: "x.circle.fill")
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerDebugger()
}
