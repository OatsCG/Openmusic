//
//  ArtistViewDL.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-09.
//

import SwiftUI

struct LibraryArtistContent: View {
    @Environment(FontManager.self) private var fontManager
    var artist: SearchedArtist
    var albums: [FetchedAlbum]
    var features: [any Track]
    var body: some View {
        ScrollView {
            VStack {
                ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 8, BlurOpacity: 0.6, cornerRadius: 0)
                HStack {
                    Text(artist.Name)
                        .customFont(fontManager, .largeTitle, bold: true)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 16)
                Spacer()
                VStack(spacing: 20) {
                    LibraryArtistShelfAlbums(albums: albums, artistName: artist.Name)
                    Divider()
                    LibraryArtistShelfFeatures(tracks: features, artistName: artist.Name)
                }
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
                        Image(systemName: "globe")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                    }
                }
            }
            .background {
                ArtistBackground_component(artwork: artist.Profile_Photo)
            }
    }
}

#Preview {
    LibraryArtistContent(artist: SearchedArtist(), albums: [], features: [
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack(),
        FetchedTrack()
    ])
}
