//
//  ControlButtons.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI

struct NPControlButtons: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                playerManager.player_backward(userInitiated: true)
            }) {
                NPBackButton_component()
            }
            Spacer()
            Button(action: {
                if playerManager.isPlaying {
                    playerManager.pause()
                } else {
                    playerManager.play()
                }
            }) {
                NPPlayButton_component()
            }
            Spacer()
            Button(action: {
                playerManager.player_forward(userInitiated: true)
            }) {
                NPSkipButton_component()
            }
            Spacer()
        }
        .foregroundStyle(.primary)
    }
}

//#Preview {
//    NowPlayingSheet()
//}
