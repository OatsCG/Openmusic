//
//  QSNPRowControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-21.
//

import SwiftUI

struct QSNPRowControls: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    playerManager.player_backward(userInitiated: true)
                }
            }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 22))
            }
            Spacer()
            Button(action: {
                if playerManager.isPlaying {
                    playerManager.pause()
                } else {
                    playerManager.play()
                }
            }) {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .contentTransition(.symbolEffect(.replace.offUp))
                    .font(.system(size: 28))
                    // ^ temporary cause of shifting
            }
            .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
            Spacer()
            Button(action: {
                withAnimation {
                    playerManager.player_forward(userInitiated: true)
                }
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 22))
            }
                .symbolEffect(.pulse, isActive: !playerManager.is_next_item_ready())
            Spacer()
        }
        .foregroundStyle(.primary)
        //.opacity(0.8)
        
    }
}

//#Preview {
//    QueueSheet()
//}

