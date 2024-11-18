//
//  QPSingleLink_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPSingleLink_linen: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var body: some View {
        HStack {
            NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: [track]))) {
                AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 7)
            }
                .padding([.top, .bottom, .leading], 10.0)
                .contextMenu {
                    LibraryAlbumMenu(album: StoredAlbum(from: [track]))
                        .environment(fontManager)
                } preview: {
                    AlbumMenuPreview_component(album: StoredAlbum(from: [track]))
                        .environment(fontManager)
                }
            Button(action: {
                playerManager.fresh_play(track: track)
            }) {
                ZStack {
                    Image(systemName: "play.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .opacity(0.7)
                }
                    .foregroundColor(.primary)
                    .font(Font.system(size: 30, weight: .regular))
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
                    .customFont(fontManager, .callout)
                Text(stringArtists(artistlist: track.Album.Artists))
                    .foregroundStyle(.secondary)
                    .customFont(fontManager, .caption)
            }
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .contextMenu {
                    TrackMenu(track: track)
                        .environment(fontManager)
                } preview: {
                    TrackMenuPreview_component(track: track)
                        .environment(fontManager)
                }
            Spacer()
        }
            .background {
                AlbumBackground(ArtworkID: track.Album.Artwork, blur: 40, light_opacity: 0.05, dark_opacity: 0.1, spin: false)
                    .allowsHitTesting(false)
            }
            .cornerRadius(10)
    }
}

#Preview {
    QPSingleLink_linen(track: FetchedTrack(default: true))
        .environment(PlayerManager())
}
