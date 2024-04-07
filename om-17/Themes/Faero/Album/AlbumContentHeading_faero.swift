//
//  AlbumContentHeading_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumContentHeading_faero: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var tracks: [any Track]?
    @State var artistScrollSize: CGFloat = 100
    var body: some View {
        VStack {
            AlbumArtDisplay(AlbumID: album.AlbumID, ArtworkID: album.Artwork, Resolution: .hd, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                    .padding([.bottom], 8)
                    .overlay {
                        AeroGlossOverlay(baseCornerRadius: 8, padding: 0)
                    }
            VStack {
                Text(separate_brackets(album.Title).main)
                    .customFont(fontManager, .title, bold: true)
                    .foregroundBlur(ArtworkID: album.Artwork)
                if (separate_brackets(album.Title).sub != "") {
                    Text(separate_brackets(album.Title).sub)
                        .customFont(fontManager, .title2, bold: true)
                        .foregroundBlur(ArtworkID: album.Artwork, fade: 0.6)
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
                    
            }
                .multilineTextAlignment(.center)
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
            .safeAreaPadding(.top, 120)
    }
}

#Preview {
    AlbumContentHeading_faero(album: SearchedAlbum(default: true))
        .environment(PlayerManager())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
