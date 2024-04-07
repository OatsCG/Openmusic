//
//  QPMultipleLink_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPMultipleLink_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var tracks: [any Track]
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: tracks.sorted{$0.Index < $1.Index}))) {
                        AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 20, BlurOpacity: 0.5, cornerRadius: 0)
                    }
                        .contextMenu {
                            LibraryAlbumMenu(album: StoredAlbum(from: tracks))
                        } preview: {
                            AlbumMenuPreview_component(album: StoredAlbum(from: tracks))
                        }
                    VStack(spacing: 10) {
                        Button(action: {
                            playerManager.fresh_play_multiple(tracks: tracks.sorted{$0.Index < $1.Index})
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
                                    playerManager.queue_songs_next(tracks: tracks)
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs(tracks: tracks)
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs_randomly(tracks: tracks)
                                } label: {
                                    Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        Button(action: {
                            playerManager.fresh_play_multiple(tracks: tracks.shuffled())
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
                                    playerManager.queue_songs_next(tracks: tracks.shuffled())
                                } label: {
                                    Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Button {
                                    playerManager.queue_songs(tracks: tracks.shuffled())
                                } label: {
                                    Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                    }
                }
                Text(tracks[0].Album.Title)
                    .foregroundStyle(.primary)
                    .customFont(fontManager, .callout)
                Text(stringArtists(artistlist: tracks[0].Album.Artists))
                    .foregroundStyle(.secondary)
                    .customFont(fontManager, .caption)
                    
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding(.all, 10.0)
            QPAlbumTracks(tracks: tracks)
            Spacer()
        }
            .background {
                Rectangle().fill(Color(white: 0.1))
                    .allowsHitTesting(false)
            }
            .cornerRadius(10)
    }
}

#Preview {
    QPMultipleLink_spotty(tracks: [FetchedTrack(default: true), FetchedTrack(default: true)])
        .environment(PlayerManager())
}

