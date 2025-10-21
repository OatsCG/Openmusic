//
//  NowPlayingOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-18.
//

import SwiftUI

struct NowPlayingOptions: View {
    @AppStorage("NowPlayingUsesCover") var NowPlayingUsesCover: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    Toggle("Use Cover instead of Sheet", isOn: $NowPlayingUsesCover)
                        .tint(.green)
                }, header: {
                    Text("NOW PLAYING")
                }, footer: {
                    Text("Use a Fullscreen Cover for the \"Now Playing\" view instead of a Sheet. This makes the view truly fullscreen, but disables the \"Swipe Down to Dismiss\" gesture.")
                })
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Now Playing")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    NowPlayingOptions()
}
