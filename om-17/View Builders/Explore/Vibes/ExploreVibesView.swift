//
//  ExploreVibesView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-20.
//

import SwiftUI

struct ExploreVibesView: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var vibesViewModel: VibesViewModel
    @State var refreshAnimateCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Vibes")
                    .customFont(fontManager, .title2, bold: true)
                Text("Choose a vibe to keep your queue going")
                    .customFont(fontManager, .body, bold: false)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 15)
            if vibesViewModel.vibeResults == nil {
                Group {
                    if vibesViewModel.isSearching {
                        ProgressView()
                    } else {
                        Text("No Vibes to show.")
                    }
                }
                .onAppear {
                    vibesViewModel.runSearch()
                }
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vibesViewModel.vibeResults?.vibes ?? [], id: \.self) { vibe in
                            VibeView(vibe: vibe)
                        }
                        Button(action: {
                            refreshAnimateCount += 1
                            Task.detached {
                                await vibesViewModel.refresh()
                            }
                        }) {
                            RefreshVibesView(refreshAnimateCount: $refreshAnimateCount)
                        }
                            .buttonStyle(.plain)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 10)
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    @Previewable @State var vibesViewModel: VibesViewModel = VibesViewModel()
    @Previewable @AppStorage("globalIPAddress") var globalIPAddress: String = "https://server.openmusic.app"
    
    ExploreVibesView(vibesViewModel: $vibesViewModel)
        .environment(PlayerManager())
}
