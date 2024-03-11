//
//  AlbumContentHeading_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI
import SwiftData

struct AlbumContentHeading_wii: View {
    @Environment(PlayerManager.self) var playerManager
    var album: SearchedAlbum
    var tracks: [any Track]?
    @State var artistScrollSize: CGFloat = 100
    var body: some View {
        VStack {
            AlbumArtDisplay(AlbumID: album.AlbumID, ArtworkID: album.Artwork, Resolution: .hd, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .padding([.bottom], 8)
            Text(separate_brackets(album.Title).main)
                .customFont(.title, bold: true)
                .foregroundBlur(ArtworkID: album.Artwork)
            if (separate_brackets(album.Title).sub != "") {
                Text(separate_brackets(album.Title).sub)
                    .customFont(.title2, bold: true)
                    .foregroundBlur(ArtworkID: album.Artwork, fade: 0.6)
            }
            Text(album.AlbumType + " • " + String(album.Year))
                .customFont(.headline)
                .foregroundBlur(ArtworkID: album.Artwork, fade: 0.7)
            Spacer()
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(album.Artists, id: \.self) {artist in
                        NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                            ArtistCookie(artist: artist)
                        }
                    }
                }
                    .scrollTargetLayout()
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    print(geo.size.width)
                                    artistScrollSize = geo.size.width
                                }
                                .onChange(of: geo.size.width) {
                                    print(geo.size.width)
                                    artistScrollSize = geo.size.width
                                }
                        }
                    )
            }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .frame(maxWidth: artistScrollSize)
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
            .multilineTextAlignment(.center)
            .safeAreaPadding(.top, 120)
    }
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "wii"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return SearchAlbumContent(album: SearchedAlbum(default: true))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "wii"
        }
}
