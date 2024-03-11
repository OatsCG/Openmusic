//
//  QPSingleLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPSingleLink_wii: View {
    @Environment(PlayerManager.self) var playerManager
    var track: any Track
    var body: some View {
        HStack {
            NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: [track]))) {
                AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .tile, Blur: 10, BlurOpacity: 0.5, cornerRadius: 14)
            }
                .padding([.top, .bottom, .leading], 10.0)
                .contextMenu {
                    LibraryAlbumMenu(album: StoredAlbum(from: [track]))
                } preview: {
                    AlbumMenuPreview_component(album: StoredAlbum(from: [track]))
                }
            Button(action: {
                playerManager.fresh_play(track: track)
            }) {
                Image(systemName: "play.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.teal, .clear)
                    //.opacity(0.6)
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
                        playerManager.queue_next(track: track)
                    } label: {
                        Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_song(track: track)
                    } label: {
                        Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                            .symbolRenderingMode(.hierarchical)
                    }
                    Button {
                        playerManager.queue_randomly(track: track)
                    } label: {
                        Label("Queue Randomly", systemImage: "arrow.up.and.down.text.horizontal")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            VStack(alignment: .leading) {
                Text(track.Title)
                    .foregroundStyle(.primary)
                    .customFont(.callout)
                Text(stringArtists(artistlist: track.Album.Artists))
                    .foregroundStyle(.secondary)
                    .customFont(.caption)
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .contextMenu {
                    TrackMenu(track: track)
                } preview: {
                    TrackMenuPreview_component(track: track)
                }
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
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
    }
}

#Preview {
    QPSingleLink_wii(track: FetchedTrack(default: true))
        .environment(PlayerManager())
}
