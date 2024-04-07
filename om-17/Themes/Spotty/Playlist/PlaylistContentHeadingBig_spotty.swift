//
//  PlaylistContentHeadingBig_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI
import SwiftData

struct PlaylistContentHeadingBig_spotty: View {
    @Environment(FontManager.self) private var fontManager
    var playlist: Playlist
    var body: some View {
        HStack(spacing: 30) {
            PlaylistArtDisplay(playlist: playlist, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
                //.scaledToFill()
                .shadow(color: .black.opacity(0.5), radius: 20)
                .padding([.bottom], 8)
                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 10.0)
            VStack(alignment: .leading) {
                Text(playlist.Title)
                    .customFont(fontManager, .largeTitle, bold: true)
                    .foregroundStyle(.primary)
                if playlist.Bio != "" {
                    Text(playlist.Bio)
                        .customFont(fontManager, .headline)
                        .foregroundStyle(.primary)
                }
                Text("\(playlist.items.count) songs")
                    .customFont(fontManager, .headline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
            .multilineTextAlignment(.leading)
            .padding(.vertical, 30)
            .safeAreaPadding(.top, 20)
            .background {
                ZStack {
                    PlaylistArtBGDisplay(playlist: playlist)
                        .blur(radius: 400, opaque: true)
                    Rectangle().fill(Color(white: 0.07))
                        .opacity(1)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                }
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .environment(\.colorScheme, .dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistContentHeadingBig_spotty(playlist: playlist)
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistContent(playlist: playlist)
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
