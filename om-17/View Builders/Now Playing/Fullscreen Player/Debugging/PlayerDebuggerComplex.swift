//
//  PlayerDebugger.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-04.
//

import SwiftUI

struct PlayerDebuggerComplex: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("playerDebugger") var playerDebugger: Bool = false
    @Binding var visibleState: DebuggerState
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Player Status:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    BufferProgressLabel(visibleState: $visibleState)
                        .font(.caption2)
                }
                    .padding(10)
                    .background(.thickMaterial)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                    .shadow(radius: 5)
            }
            HStack {
                Spacer()
                Button(action: {
                    if let audioID = playerManager.currentQueueItem?.fetchedPlayback?.YT_Audio_ID {
                        UIPasteboard.general.string = "youtube.com/watch?v=\(audioID)"
                        ToastManager.shared.propose(toast: Toast(artworkID: "", message: "Copied YT Link", .systemSuccess))
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Copy YouTube URL")
                            if let audioID = playerManager.currentQueueItem?.fetchedPlayback?.YT_Audio_ID {
                                Text("youtube.com/watch?v=\(audioID)")
                                    .font(.caption2)
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("nil")
                                    .font(.caption2)
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Image(systemName: "doc.on.doc.fill")
                    }
                }
                    .foregroundStyle(playerManager.currentQueueItem?.fetchedPlayback == nil ? .secondary : .primary)
                    .disabled(playerManager.currentQueueItem?.fetchedPlayback == nil)
                    .buttonStyle(.plain)
                    .padding(10)
                    .background(.thickMaterial)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                    .shadow(radius: 5)
            }
            HStack {
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL
                    ToastManager.shared.propose(toast: Toast(artworkID: "", message: "Copied Playback Link", .systemSuccess))
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Copy Playback URL")
                            Text(playerManager.currentQueueItem?.fetchedPlayback?.Playback_Audio_URL ?? "nil")
                                .font(.caption2)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                        Image(systemName: "doc.on.doc.fill")
                    }
                }
                    .foregroundStyle(playerManager.currentQueueItem?.fetchedPlayback == nil ? .secondary : .primary)
                    .disabled(playerManager.currentQueueItem?.fetchedPlayback == nil)
                    .buttonStyle(.plain)
                    .padding(10)
                    .background(.thickMaterial)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                    .shadow(radius: 5)
            }
        }
            .padding(10)
            .opacity(playerDebugger ? 1 : 0)
    }
}

#Preview {
    PlayerDebugger()
}
