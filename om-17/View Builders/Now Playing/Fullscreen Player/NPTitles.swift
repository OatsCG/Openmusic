//
//  NPTitles.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-12.
//

import SwiftUI
import MarqueeText
import SwiftData

struct NPTitles: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Query(sort: \StoredPlaylist.dateCreated) private var playlists: [StoredPlaylist]
    @Binding var showingNPSheet: Bool
    @Binding var fullscreen: Bool
    @Binding var passedNSPath: NavigationPath
    var body: some View {
        VStack(spacing: 0) {
            if (playerManager.currentQueueItem == nil) {
                VStack(alignment: .leading, spacing: 30) {
                    MarqueeText(
                        text: "Not Playing",
                        font: FontManager.currentThemeUIFont(.title, bold: true),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3,
                        alignment: fullscreen ? .center : .leading
                    )
                    .padding(.top, 30)
                }
            } else {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        VStack(spacing: 0) {
                            MarqueeText(
                                text: playerManager.currentQueueItem!.Track.Title,
                                font: FontManager.currentThemeUIFont(.title, bold: true),
                                leftFade: 10,
                                rightFade: 10,
                                startDelay: 3,
                                alignment: fullscreen ? .center : .leading
                            )
                            if !playerManager.currentQueueItem!.Track.Features.isEmpty {
                                Menu {
                                    ForEach(playerManager.currentQueueItem!.Track.Features, id: \.ArtistID) { artist in
                                        Button(action: {}) {
                                            Label(artist.Name, systemImage: "")
                                        }
                                    }
                                } label: {
                                    MarqueeText(
                                        text: "feat. \(stringArtists(artistlist: playerManager.currentQueueItem!.Track.Features))",
                                        font: FontManager.currentThemeUIFont(.headline),
                                        leftFade: 10,
                                        rightFade: 10,
                                        startDelay: 3,
                                        alignment: fullscreen ? .center : .leading
                                    )
                                        .foregroundStyle(.secondary)
                                }
                                    .buttonStyle(.plain)
                            }
                        }
                        Spacer()
                        if !fullscreen {
                            Menu {
                                NPMenu(queueItem: playerManager.currentQueueItem, playlists: playlists, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .customFont(.title)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
    }
}

//#Preview {
//    NPTitle()
//}
