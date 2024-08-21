//
//  AlbumContentHeadingBig_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI
import SwiftData

struct AlbumContentHeadingBig_classic: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var tracks: [any Track]?
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            AlbumArtDisplay(AlbumID: album.AlbumID, ArtworkID: album.Artwork, Resolution: .hd, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 10.0)
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text(separate_brackets(album.Title).main)
                        .customFont(fontManager, .largeTitle, bold: true)
                        .foregroundBlur(ArtworkID: album.Artwork)
                    if (separate_brackets(album.Title).sub != "") {
                        Text(separate_brackets(album.Title).sub)
                            .customFont(fontManager, .title2, bold: true)
                            .foregroundBlur(ArtworkID: album.Artwork, fade: 0.6)
                    }
                }
                Text(album.AlbumType + " • " + String(album.Year))
                    .customFont(fontManager, .headline)
                    .foregroundBlur(ArtworkID: album.Artwork, fade: 0.7)
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(album.Artists, id: \.self) {artist in
                            NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                                ArtistCookie(artist: artist)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                Spacer()
                HStack(spacing: 10) {
                    Button (action: {
                        if tracks != nil {
                            playerManager.fresh_play_multiple(tracks: tracks!)
                        }
                    }) {
                        AlbumWideButton_component(text: "Play", ArtworkID: album.Artwork)
                    }
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                        
                    Button (action: {
                        if tracks != nil {
                            playerManager.fresh_play_multiple(tracks: tracks!.shuffled())
                        }
                    }) {
                        AlbumWideButton_component(text: "Shuffle", ArtworkID: album.Artwork)
                    }
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                }
                    .buttonStyle(.plain)
                    .foregroundStyle(tracks == nil ? .secondary : .primary)
            }
            Spacer()
        }
            .multilineTextAlignment(.leading)
            .safeAreaPadding(.top, 60)
            .padding(.leading, 30)
            .padding(.bottom, 15)
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ScrollView {
        AlbumContentHeadingBig_classic(album: SearchedAlbum(default: true), tracks: [])
            //.frame(height: 200)
            .border(.red)
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
        }
}
