//
//  QPMultipleLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI
import Combine

struct QPMultipleLink_wii: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(\.colorScheme) var colorScheme
    var tracks: [any Track]
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(value: LibraryAlbumContentNPM(album: StoredAlbum(from: tracks.sorted{$0.Index < $1.Index}))) {
                        AlbumArtDisplay(ArtworkID: tracks[0].Album.Artwork, Resolution: .tile, Blur: 10, BlurOpacity: 0.5, cornerRadius: 14)
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
    VStack(spacing: 10) {
        QPMultipleLink_wii(tracks: [FetchedTrack(), FetchedTrack()])
            //.aspectRatio(2.8 / 1.0, contentMode: .fill)
        QPMultipleLink_wii(tracks: [FetchedTrack(), FetchedTrack()])
            //.aspectRatio(2.8 / 1.0, contentMode: .fill)
    }
        .environment(PlayerManager())
}

//LibraryRecentsList
#Preview {
    VStack {
        HStack {
            Button(action: {
            }) {
                //AlbumWideButton_component(text: "Play", ArtworkID: "")
            }
                .clipped()
                .contentShape(RoundedRectangle(cornerRadius: 10))
            Button(action: {
            }) {
                //AlbumWideButton_component(text: "Shuffle", ArtworkID: "")
            }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        VStack {
            QPMultipleLink_wii(tracks: [FetchedTrack(), FetchedTrack()])
        }
    }
    .environment(PlayerManager())
}



#Preview {
    QPMultipleLink_wii(tracks: [FetchedTrack(default: true), FetchedTrack(default: true)])
        .environment(PlayerManager())
}
