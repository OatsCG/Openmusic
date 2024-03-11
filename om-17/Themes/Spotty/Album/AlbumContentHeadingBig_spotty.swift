//
//  AlbumContentHeadingBig_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI
import SwiftData

struct AlbumContentHeadingBig_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    var album: SearchedAlbum
    var tracks: [any Track]?
    var body: some View {
        VStack {
            HStack(spacing: 30) {
                AlbumArtDisplay(AlbumID: album.AlbumID, ArtworkID: album.Artwork, Resolution: .hd, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
                    .shadow(color: .black.opacity(0.5), radius: 20)
                    .padding([.bottom], 8)
                    .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 10.0)
                VStack(alignment: .leading) {
                    Text(separate_brackets(album.Title).main)
                        .customFont(.largeTitle, bold: true)
                        .foregroundStyle(.primary)
                    if (separate_brackets(album.Title).sub != "") {
                        Text(separate_brackets(album.Title).sub)
                            .customFont(.title2, bold: true)
                            .foregroundStyle(.primary)
                            .opacity(0.8)
                    }
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
                    Text(album.AlbumType + " • " + String(album.Year))
                        .customFont(.headline)
                        .foregroundStyle(.secondary)
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
            .padding(.vertical, 30)
            .safeAreaPadding(.top, 20)
            .background {
                ZStack {
                    AlbumBackground(ArtworkID: album.Artwork, blur: 400, light_opacity: 1, dark_opacity: 1, spin: false)
                    Rectangle().fill(Color(white: 0.07))
                        .opacity(1)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                }
                .ignoresSafeArea()
            }
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    AlbumContentHeadingBig_spotty(album: SearchedAlbum(default: true))
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ScrollView {
        AlbumContentHeadingBig_spotty(album: SearchedAlbum(default: true), tracks: [])
            //.frame(height: 200)
            .border(.red)
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "spotty"
        }
}
