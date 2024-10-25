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
    @Environment(FontManager.self) private var fontManager
    @Environment(BackgroundDatabase.self) var database  // was \.modelContext
    @State var playlists: [StoredPlaylist] = []
    @Binding var showingNPSheet: Bool
    @Binding var fullscreen: Bool
    @Binding var passedNSPath: NavigationPath
    var body: some View {
        VStack(spacing: 0) {
            if (playerManager.currentQueueItem == nil) {
                VStack(alignment: .leading, spacing: 30) {
                    MarqueeText(
                        text: playerManager.fetchSuggestionsModel.isFetching ? "Loading..." : "Not Playing",
                        font: FontManager.shared.currentThemeUIFont(fontManager, .title, bold: true),
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
                                font: FontManager.shared.currentThemeUIFont(fontManager, .title, bold: true),
                                leftFade: 10,
                                rightFade: 10,
                                startDelay: 3,
                                alignment: fullscreen ? .center : .leading
                            )
                            if (fullscreen) {
                                Menu {
                                    Section("Artists") {
                                        ForEach(playerManager.currentQueueItem!.Track.Album.Artists, id: \.ArtistID) { artist in
                                            Button(action: {}) {
                                                Label(artist.Name, systemImage: "person.circle.fill")
                                            }
                                        }
                                    }
                                } label: {
                                    MarqueeText(
                                        text: stringArtists(artistlist: playerManager.currentQueueItem!.Track.Album.Artists),
                                        font: FontManager.shared.currentThemeUIFont(fontManager, .headline, bold: true),
                                        leftFade: 10,
                                        rightFade: 10,
                                        startDelay: 3,
                                        alignment: fullscreen ? .center : .leading
                                    )
                                        .foregroundStyle(.secondary)
                                }
                                    .buttonStyle(.plain)
                            }
                            if (playerManager.currentQueueItem!.Track.Features.isEmpty || stringArtists(artistlist: playerManager.currentQueueItem!.Track.Features, exclude: playerManager.currentQueueItem!.Track.Album.Artists) == "") == false {
                                Menu {
                                    Section("Features") {
                                        ForEach(playerManager.currentQueueItem!.Track.Features, id: \.ArtistID) { artist in
                                            Button(action: {}) {
                                                Label(artist.Name, systemImage: "person.circle.fill")
                                            }
                                        }
                                    }
                                } label: {
                                    MarqueeText(
                                        text: "feat. \(stringArtists(artistlist: playerManager.currentQueueItem!.Track.Features, exclude: playerManager.currentQueueItem!.Track.Album.Artists))",
                                        font: FontManager.shared.currentThemeUIFont(fontManager, fullscreen ? .callout : .headline),
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
                                NPMenu(queueItem: playerManager.currentQueueItem, playlists: $playlists, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .customFont(fontManager, .title)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .onAppear {
                self.updatePlaylists()
            }
    }
    func updatePlaylists() {
        Task {
            let predicate = #Predicate<StoredPlaylist> { _ in true }
            let sortDescriptors = [SortDescriptor(\StoredPlaylist.dateCreated, order: .reverse)]
            let playlists = try? await database.fetch(predicate, sortBy: sortDescriptors)
            if let playlists = playlists {
                await MainActor.run {
                    self.playlists = playlists
                }
            } else {
                await MainActor.run {
                    self.playlists = []
                }
            }
        }
    }
}

//#Preview {
//    NPTitle()
//}
