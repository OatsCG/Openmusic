//
//  PlaylistReviewTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-02.
//

import SwiftUI
import MarqueeText

struct PlaylistReviewTracks: View {
    @State var playlist: StoredPlaylist
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("The following imports couldn't be matched automatically.\nChoose the closest fit for each song, or choose \"Disregard\" to remove the import from the playlist.")
                    .padding(.bottom, 10)
                    .customFont(.body, bold: true)
                
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
        }
            .safeAreaPadding(.bottom, 80)
            .tint(.none)
    }
}

//#Preview {
//    PlaylistReviewTracks()
//}

struct ImportToReview: View {
    @Binding var playlist: StoredPlaylist
    @State var playlistItem: PlaylistItem
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Imported as:")
                        .customFont(.caption, bold: true)
                        .foregroundStyle(.secondary)
                    MarqueeText(
                        text: playlistItem.importData.from.title ?? "",
                        font: FontManager.currentThemeUIFont(.body, bold: true),
                        leftFade: 8,
                        rightFade: 8,
                        startDelay: 0
                    )
                    MarqueeText(
                        text: playlistItem.importData.from.album ?? "",
                        font: FontManager.currentThemeUIFont(.callout),
                        leftFade: 8,
                        rightFade: 8,
                        startDelay: 0
                    )
                    MarqueeText(
                        text: playlistItem.importData.from.artist ?? "",
                        font: FontManager.currentThemeUIFont(.callout),
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
                } label: {
                    Label("Disregard", systemImage: "minus.circle")
                }
                    .buttonStyle(.borderedProminent)
            }
            Divider()
            HStack {
                Text("Options:")
                    .customFont(.caption, bold: true)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(playlistItem.importData.possibleImports, id: \.self) {importedTrack in
                        TrackToReview(playlist: $playlist, playlistItem: $playlistItem, importedTrack: importedTrack)
                        //Spacer()
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
    @Binding var playlist: StoredPlaylist
    @Binding var playlistItem: PlaylistItem
    @State var importedTrack: ImportedTrack
    @Environment(PlaylistImporter.self) var playlistImporter
    var body: some View {
        Button(action: {
            var newPlaylistItem = playlistItem
            withAnimation {
                newPlaylistItem.track = FetchedTrack(from: importedTrack)
                newPlaylistItem.explicit = newPlaylistItem.track.Playback_Explicit != nil
                newPlaylistItem.importData.status = .success
                playlist.mutate_item(item: newPlaylistItem)
                //playlistImporter.publish_successful_track(playlistImport: playlistItem, track: importedTrack)
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
                    font: FontManager.currentThemeUIFont(.caption2, bold: true),
                    leftFade: 8,
                    rightFade: 8,
                    startDelay: 0
                )
                MarqueeText(
                    text: importedTrack.Album.Title,
                    font: FontManager.currentThemeUIFont(.caption2),
                    leftFade: 8,
                    rightFade: 8,
                    startDelay: 0
                )
                MarqueeText(
                    text: stringArtists(artistlist: importedTrack.Album.Artists),
                    font: FontManager.currentThemeUIFont(.caption2),
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
