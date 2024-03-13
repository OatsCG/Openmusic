//
//  NPPlayButton_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPPlayButton_faero: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
            .contentTransition(.symbolEffect(.replace.offUp))
            .font(.system(size: playerManager.isPlaying ? 51.2 : 50.1))
            .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
    }
}

#Preview {
    NPPlayButton_faero()
}
