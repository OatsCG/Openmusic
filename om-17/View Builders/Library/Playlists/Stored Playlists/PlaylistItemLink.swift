//
//  PlaylistItemLink.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI
import SwiftData

struct PlaylistItemLink: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var item: PlaylistItem
    var playlist: StoredPlaylist
    var index: Int
    @State var subtext: String = ""
    var body: some View {
        Button(action: {
            let nextItems: [PlaylistItem] = Array(playlist.items.suffix(from: index)).filter({ $0.importData.status == .success })
            playerManager.fresh_play_multiple(tracks: nextItems)
        }) {
            HStack {
                if (item.importData.status != .success) {
                    if (item.importData.status == .hold) {
                        Image(systemName: "circle.dashed")
                    } else if (item.importData.status == .importing) {
                        ProgressView()
                    } else {
                        Image(systemName: "exclamationmark.circle")
                    }
                    VStack(alignment: .leading) {
                        Text(item.importData.from.title ?? "")
                            .foregroundColor(.primary)
                            .customFont(fontManager, .callout)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        HStack {
                            Text("Review track in Playlist Settings")
                                .customFont(fontManager, .caption)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                            Image(systemName: "gear")
                        }
                            .foregroundStyle(.secondary)
                    }
                } else {
                    if (playerManager.currentQueueItem?.Track.TrackID == item.track.TrackID) {
                        TrackSpeakerIcon()
                    }
                    AlbumArtDisplay(ArtworkID: item.track.Album.Artwork, Resolution: .cookie, Blur: 40, BlurOpacity: 0.4, cornerRadius: 4)
                    VStack(alignment: .leading) {
                        Text(item.track.Title)
                            .foregroundColor(.primary)
                            .customFont(fontManager, .callout)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        Text(subtext)
                            .foregroundColor(.secondary)
                            .customFont(fontManager, .caption)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                }
                Spacer()
                PlaybackModesIcon(track: item.track)
            }
                .padding([.top, .bottom], 10)
                .contentShape(Rectangle())
        }
            .buttonStyle(.plain)
            .contextMenu {
                TrackMenu(track: item.track)
                    .environment(fontManager)
            } preview: {
                TrackMenuPreview_component(track: item.track)
                    .environment(fontManager)
            }
            .padding(0)
            .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
            //.aspectRatio(11 / 2, contentMode: .fit)
            //.aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
            .disabled(item.importData.status != .success)
            .onAppear {
                updateSubtext()
            }
    }
    func updateSubtext() {
        Task {
            let time: String = secondsToText(seconds: item.track.Length)
            let features: String = (item.track.Features.count > 0) ? (" • " + stringArtists(artistlist: item.track.Features)) : ""
            let artists: String
            // if artists > 0 and artists are unique from features
            if item.track.Album.Artists.count > 0 && !item.track.Features.contains(where: { item.track.Album.Artists.contains($0) }) {
                artists = " • " + stringArtists(artistlist: item.track.Album.Artists, exclude: item.track.Features)
            } else {
                artists = ""
            }
            await MainActor.run {
                self.subtext = time + artists + features
            }
        }
    }
}

