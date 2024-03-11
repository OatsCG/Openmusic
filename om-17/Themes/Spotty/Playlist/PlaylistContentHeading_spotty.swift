//
//  PlaylistContentHeading_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-05.
//

import SwiftUI
import SwiftData

struct PlaylistContentHeading_spotty: View {
    var playlist: Playlist
    var body: some View {
        VStack(alignment: .leading) {
            PlaylistArtDisplay(playlist: playlist, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
                .scaledToFill()
                .shadow(color: .black.opacity(0.5), radius: 20)
                .padding([.bottom], 8)
                .padding(.horizontal, 40)
            VStack(alignment: .leading) {
                Text(playlist.Title)
                    .customFont(.title, bold: true)
                    .foregroundStyle(.primary)
                if playlist.Bio != "" {
                    Text(playlist.Bio)
                        .customFont(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                Text("\(playlist.items.count) songs")
                    .customFont(.headline)
                    .foregroundStyle(.secondary)
            }
                .padding(.horizontal, 20)
        }
            .multilineTextAlignment(.leading)
            .padding(.vertical, 30)
            .safeAreaPadding(.top, 80)
            .background {
                ZStack {
                    PlaylistArtBGDisplay(playlist: playlist)
                        .blur(radius: 400, opaque: true)
                        .scaledToFill()
                    Rectangle().fill(Color(white: 0.07))
                        .scaledToFill()
                        .opacity(1)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                }
                .ignoresSafeArea()
            }
            .environment(\.colorScheme, .dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistContentHeading_spotty(playlist: playlist)
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
