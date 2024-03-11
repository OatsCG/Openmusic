//
//  NPPlayButton_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPPlayButton_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
            .contentTransition(.symbolEffect(.replace.offUp))
            //.font(.system(size: playerManager.is_playing() ? 61.44 : 60.12))
            .font(.system(size: 60))
            .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
    }
}

#Preview {
    NPPlayButton_spotty()
}
