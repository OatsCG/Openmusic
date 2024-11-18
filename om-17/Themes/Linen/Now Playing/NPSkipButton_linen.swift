//
//  NPSkipButton_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPSkipButton_linen: View {
    @Environment(PlayerManager.self) var playerManager
    var body: some View {
        Image(systemName: "forward.fill")
            .font(.system(size: 36))
            .symbolEffect(.pulse, isActive: !playerManager.is_next_item_ready())
    }
}

#Preview {
    NPSkipButton_linen()
}
