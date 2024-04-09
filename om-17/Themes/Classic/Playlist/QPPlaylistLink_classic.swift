//
//  QPPlaylistLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI
import SwiftData

struct QPPlaylistLink_classic: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var playlist: StoredPlaylist
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(value: PlaylistContentNPM(playlist: playlist)) {
                        PlaylistArtDisplay(playlist: playlist, Blur: 20, BlurOpacity: 0.5, cornerRadius: 7)
                            .overlay {
                                if (playlist.pinned) {
                                    Image(systemName: "pin.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7), .ultraThinMaterial)
                                        .font(.headline)
                                        .rotationEffect(.degrees(45))
                                        .position(x: 3, y: 3)
                                }
                            }
                    }
                        .contextMenu {
                            PlaylistMenu(playlist: playlist)
                                .environment(fontManager)
                        } preview: {
                            PlaylistMenuPreview_component(playlist: playlist)
                                .environment(fontManager)
                        }
                    VStack(spacing: 10) {
                        Button(action: {
                            playerManager.fresh_play_multiple(tracks: playlist.items)
                        }) {
                            ZStack {
                                Image(systemName: "play.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .opacity(0.6)
                            }
                                .foregroundColor(.primary)
                                .font(Font.system(size: 30, weight: .regular))
                        }
                            .contextMenu {
                                Button {
                                    playerManager.queue_songs_next(tracks: playlist.items)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs(tracks: playlist.items)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs_randomly(tracks: playlist.items)
                                } label: {
                                    Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        Button(action: {
                            playerManager.fresh_play_multiple(tracks: playlist.items.shuffled())
                        }) {
                            ZStack {
                                Image(systemName: "shuffle.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .opacity(0.6)
                            }
                                .foregroundColor(.primary)
                                .font(Font.system(size: 30, weight: .regular))
                        }
                            .contextMenu {
                                Button {
                                    playerManager.queue_songs_next(tracks: playlist.items.shuffled())
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs(tracks: playlist.items.shuffled())
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                    }
                }
                Text(playlist.Title)
                    .foregroundStyle(.primary)
                    .customFont(fontManager, .callout)
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding(.all, 10.0)
            QPPlaylistTracks(items: playlist.items)
            Spacer()
        }
            .background {
                PlaylistBackground(playlist: playlist, blur: 40, light_opacity: 0.2, dark_opacity: 0.1, spin: false)
                    .allowsHitTesting(false)
            }
            .cornerRadius(10)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return QPPlaylistLink_classic(playlist: playlist)
        .environment(PlayerManager())
        .modelContainer(container)
}
