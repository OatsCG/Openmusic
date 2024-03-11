//
//  NPSkipButton_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPSkipButton_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        Image(systemName: "forward.end.fill")
            .font(.system(size: 32))
            .symbolEffect(.pulse, isActive: !playerManager.is_next_item_ready())
    }
}

#Preview {
    NPSkipButton_spotty()
}
