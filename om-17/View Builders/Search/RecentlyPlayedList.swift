//
//  RecentlyPlayedList.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-29.
//

import SwiftUI

struct RecentlyPlayedList: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @AppStorage("recentlyPlayed") var recentlyPlayed: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recently Discovered")
                    .customFont(fontManager, .title2, bold: true)
                Spacer()
                Button(action: {
                    withAnimation {
                        recentlyPlayed = ""
                    }
                }) {
                    Text("Clear")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                    .buttonStyle(.plain)
                    .disabled(recentlyPlayed == "")
            }
            Divider()
            ForEach(Array(RecentlyPlayedManager.getRecentTracks().prefix(50).enumerated()), id: \.offset) { index, track in
                Button(action: {
                    playerManager.fresh_play(track: track)
                }) {
                    TrackLink_component(track: track)
                }
                    .buttonStyle(.plain)
                    .contextMenu {
                        TrackMenu(track: track)
                            .environment(fontManager)
                    } preview: {
                        TrackMenuPreview_component(track: track)
                            .environment(fontManager)
                    }
            }
        }
            .padding(.horizontal, 20)
    }
}

#Preview {
    RecentlyPlayedList()
}
