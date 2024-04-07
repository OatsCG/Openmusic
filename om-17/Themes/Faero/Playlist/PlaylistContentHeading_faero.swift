//
//  PlaylistContentHeading_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-05.
//

import SwiftUI
import SwiftData

struct PlaylistContentHeading_faero: View {
    @Environment(FontManager.self) private var fontManager
    var playlist: Playlist
    var body: some View {
        VStack {
            PlaylistArtDisplay(playlist: playlist, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .padding([.bottom], 8)
                .overlay {
                    AeroGlossOverlay(baseCornerRadius: 8, padding: 0)
                }
            Text(playlist.Title)
                .customFont(fontManager, .title, bold: true)
                .foregroundBlur(playlist: playlist)
            if playlist.Bio != "" {
                Text(playlist.Bio)
                    .customFont(fontManager, .headline)
                    .foregroundBlur(playlist: playlist, fade: 0.5)
                Spacer()
            }
            Text("\(playlist.items.count) songs")
                .customFont(fontManager, .headline)
                .foregroundBlur(playlist: playlist, fade: 0.8)
        }
            .multilineTextAlignment(.center)
            .safeAreaPadding(.top, 120)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistContentHeading_faero(playlist: playlist)
        .modelContainer(container)
}
