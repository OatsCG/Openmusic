//
//  QPPlaylistLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI
import SwiftData

struct QPPlaylistLink_wii: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PlayerManager.self) var playerManager
    var playlist: StoredPlaylist
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(value: PlaylistContentNPM(playlist: playlist)) {
                        PlaylistArtDisplay(playlist: playlist, Blur: 10, BlurOpacity: 0.5, cornerRadius: 14)
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
                        } preview: {
                            PlaylistMenuPreview_component(playlist: playlist)
                        }
                    VStack(spacing: 10) {
                        Button(action: {
                            playerManager.fresh_play_multiple(tracks: playlist.items)
                        }) {
                            Image(systemName: "play.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.teal, .clear)
                                .font(Font.system(size: 30, weight: .regular))
                                .background {
                                    ZStack {
                                        Image(.wiibutton)
                                            .resizable()
                                        Circle().fill(.clear)
                                            .stroke(.wiiborder, lineWidth: 3)
                                    }
                                    .clipShape(Circle())
                                }
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
                            Image(systemName: "shuffle.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.teal, .clear)
                                .font(Font.system(size: 30, weight: .regular))
                                .background {
                                    ZStack {
                                        Image(.wiibutton)
                                            .resizable()
                                        Circle().fill(.clear)
                                            .stroke(.wiiborder, lineWidth: 3)
                                    }
                                    .clipShape(Circle())
                                }
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
                    .customFont(.callout)
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding(.all, 10.0)
            QPPlaylistTracks(items: playlist.items)
            Spacer()
        }
            .background {
                TVStaticBackground()
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.primary.opacity(0.2), lineWidth: 2)
            )
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return QPPlaylistLink_wii(playlist: playlist)
        .environment(PlayerManager())
        .modelContainer(container)
}
