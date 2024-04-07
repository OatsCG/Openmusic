//
//  PlaylistContentHeadingBig_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI
import SwiftData

struct PlaylistContentHeadingBig_faero: View {
    @Environment(FontManager.self) private var fontManager
    var playlist: Playlist
    var body: some View {
        HStack(spacing: 30) {
            PlaylistArtDisplay(playlist: playlist, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .padding([.bottom], 8)
                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 10.0)
                .overlay {
                    AeroGlossOverlay(baseCornerRadius: 8, padding: 0)
                }
            VStack(alignment: .leading) {
                Text(playlist.Title)
                    .customFont(fontManager, .largeTitle, bold: true)
                    .foregroundBlur(playlist: playlist)
                if playlist.Bio != "" {
                    Text(playlist.Bio)
                        .customFont(fontManager, .headline)
                        .foregroundBlur(playlist: playlist, fade: 0.5)
                }
                Text("\(playlist.items.count) songs")
                    .customFont(fontManager, .headline)
                    .foregroundBlur(playlist: playlist, fade: 0.8)
            }
            Spacer()
        }
            .multilineTextAlignment(.leading)
            .safeAreaPadding(.top, 60)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistContentHeadingBig_faero(playlist: playlist)
        .modelContainer(container)
}
