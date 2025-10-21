//
//  PlaylistReviewTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-02.
//

import SwiftUI
import MarqueeText

struct PlaylistReviewTracks: View {
    @Environment(FontManager.self) private var fontManager
    @State var playlist: StoredPlaylist
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("The following imports couldn't be matched automatically.\nChoose the closest fit for each song, or choose \"Disregard\" to remove the import from the playlist.")
                    .padding(.bottom, 10)
                    .customFont(fontManager, .body, bold: true)
                
                Divider()
                ForEach(playlist.items, id: \.self) {playlistItem in
                    if ([.uncertain, .zeroed].contains(playlistItem.importData.status)) {
                        ImportToReview(playlist: $playlist, playlistItem: playlistItem)
                        Divider()
                    }
                }
            }
                .multilineTextAlignment(.center)
                .padding(10)
                .padding(.top, 1)
        }
            .safeAreaPadding(.bottom, 80)
            .tint(.none)
    }
}

struct ImportToReview: View {
    @Environment(FontManager.self) private var fontManager
    @Environment(BackgroundDatabase.self) private var database
    @Binding var playlist: StoredPlaylist
    @State var playlistItem: PlaylistItem
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Imported as:")
                        .customFont(fontManager, .caption, bold: true)
                        .foregroundStyle(.secondary)
                    MarqueeText(
                        text: playlistItem.importData.from.title ?? "",
                        font: FontManager.shared.currentThemeUIFont(fontManager, .body, bold: true),
                        leftFade: 8,
                        rightFade: 8,
                        startDelay: 0
                    )
                    MarqueeText(
                        text: playlistItem.importData.from.album ?? "",
                        font: FontManager.shared.currentThemeUIFont(fontManager, .callout),
                        leftFade: 8,
                        rightFade: 8,
                        startDelay: 0
                    )
                    MarqueeText(
                        text: playlistItem.importData.from.artist ?? "",
                        font: FontManager.shared.currentThemeUIFont(fontManager, .callout),
                        leftFade: 8,
                        rightFade: 8,
                        startDelay: 0
                    )
                }
                    .lineLimit(1)
                Spacer()
                Button(role: .destructive) {
                    withAnimation {
                        playlist.items.removeAll(where: { $0.id == playlistItem.id })
                    }
                    try? database.save()
                } label: {
                    Label("Disregard", systemImage: "minus.circle")
                }
                    .buttonStyle(.borderedProminent)
            }
            Divider()
            HStack {
                Text("Choices:")
                    .customFont(fontManager, .caption, bold: true)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(playlistItem.importData.possibleImports, id: \.self) {importedTrack in
                        TrackToReview(playlist: $playlist, playlistItem: $playlistItem, importedTrack: importedTrack)
                    }
                }
            }
        }
            .padding(10)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct TrackToReview: View {
    @Environment(PlaylistImporter.self) var playlistImporter
    @Environment(FontManager.self) private var fontManager
    @Environment(BackgroundDatabase.self) private var database
    @Binding var playlist: StoredPlaylist
    @Binding var playlistItem: PlaylistItem
    @State var importedTrack: ImportedTrack
    
    var body: some View {
        Button(action: {
            var newPlaylistItem = playlistItem
            withAnimation {
                newPlaylistItem.track = FetchedTrack(from: importedTrack)
                newPlaylistItem.explicit = newPlaylistItem.track.Playback_Explicit != nil
                newPlaylistItem.importData.status = .success
                playlist.mutate_item(item: newPlaylistItem)
                try? database.save()
            }
        }) {
            VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading) {
                    BetterAsyncImage(url: BuildArtworkURL(imgID: importedTrack.Album.Artwork, resolution: .tile), animated: false)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                MarqueeText(
                    text: importedTrack.Title,
                    font: FontManager.shared.currentThemeUIFont(fontManager, .caption2, bold: true),
                    leftFade: 8,
                    rightFade: 8,
                    startDelay: 0
                )
                MarqueeText(
                    text: importedTrack.Album.Title,
                    font: FontManager.shared.currentThemeUIFont(fontManager, .caption2),
                    leftFade: 8,
                    rightFade: 8,
                    startDelay: 0
                )
                MarqueeText(
                    text: stringArtists(artistlist: importedTrack.Album.Artists),
                    font: FontManager.shared.currentThemeUIFont(fontManager, .caption2),
                    leftFade: 8,
                    rightFade: 8,
                    startDelay: 0
                )
                PlaybackExplicityDownloadedIcon(track: importedTrack, explicit: importedTrack.Playback_Explicit != nil)
            }
                .containerRelativeFrame(.horizontal, count: 7, span: 3, spacing: 10)
                .padding(5)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .lineLimit(1)
        }
        .buttonStyle(.plain)
        .scaledToFill()
    }
}
