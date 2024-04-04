//
//  PlayerDebugger.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-04.
//

import SwiftUI

struct PlayerDebugger: View {
    @AppStorage("playerDebugger") var playerDebugger: Bool = false
    @State var visibleState: DebuggerState = .hidden
    var body: some View {
        VStack {
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
                    .padding(10)
            }
        }
            .opacity(playerDebugger ? 1 : 0)
    }
}

#Preview {
    PlayerDebugger()
}
