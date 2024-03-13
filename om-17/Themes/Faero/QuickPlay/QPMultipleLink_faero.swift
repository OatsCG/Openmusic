//
//  QPMultipleLink_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPMultipleLink_faero: View {
    @Environment(PlayerManager.self) var playerManager
    var tracks: [any Track]
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: tracks.sorted{$0.Index < $1.Index}))) {
                        AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 20, BlurOpacity: 0.5, cornerRadius: 7)
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
                            Image(systemName: "play.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.foreground.secondary, .clear)
                                .font(Font.system(size: 30, weight: .regular))
                                .background {
                                    ZStack {
                                        AeroGlossBG(cornerRadius: 0)
                                            .overlay {
                                                AeroGlossOverlay(baseCornerRadius: 0, padding: 0)
                                            }
                                    }
                                    .clipShape(Circle())
                                }
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
                            Image(systemName: "shuffle.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.foreground.secondary, .clear)
                                .font(Font.system(size: 30, weight: .regular))
                                .background {
                                    ZStack {
                                        AeroGlossBG(cornerRadius: 0)
                                            .overlay {
                                                AeroGlossOverlay(baseCornerRadius: 0, padding: 0)
                                            }
                                    }
                                    .clipShape(Circle())
                                }
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
                    .customFont(.callout)
                Text(stringArtists(artistlist: tracks[0].Album.Artists))
                    .foregroundStyle(.secondary)
                    .customFont(.caption)
                    
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding(.all, 10.0)
            QPAlbumTracks(tracks: tracks)
            Spacer()
        }
            .background {
                AeroGlossBG(cornerRadius: 10)
                    .opacity(0.6)
                    .allowsHitTesting(false)
            }
            .overlay {
                AeroGlossOverlay(baseCornerRadius: 10, padding: 5)
            }
            .cornerRadius(10)
    }
}

#Preview {
    QPMultipleLink_faero(tracks: [FetchedTrack(default: true), FetchedTrack(default: true)])
        .environment(PlayerManager())
}
