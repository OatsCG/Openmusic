//
//  DebugOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-12.
//

import SwiftUI

struct DebugOptions: View {
    @AppStorage("playerDebugger") var playerDebugger: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Enable Player Debugger", isOn: $playerDebugger)
                        .tint(.green)
                } header: {
                    Text("DEBUG")
                } footer: {
                    Text("Enables a label in the Now Playing view that shows the current playback status of the player.")
                }
            }
        }
    }
}

#Preview {
    DebugOptions()
}
