//
//  ArtistView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI
import SwiftData

struct SearchArtistContent: View {
    var artist: SearchedArtist
    @State var artistModel = ArtistViewModel()
    var body: some View {
        ScrollView {
            VStack {
                if artistModel.fetchedArtist == nil {
                    SearchArtistContentHeader_component(artist: artist)
                    Spacer()
                    LoadingSearchResults_component()
                        .task {
                            artistModel.runSearch(artistID: artist.ArtistID)
                        }
                } else {
                    FetchedArtistContentHeader_component(artist: artistModel.fetchedArtist!)
                    Spacer()
                    VStack(spacing: 20) {
                        SearchArtistShelfTracks(tracks: artistModel.fetchedArtist!.Tracks, artistName: artistModel.fetchedArtist!.Name)
                        Divider()
                        SearchArtistShelfAlbums(albums: artistModel.fetchedArtist!.Albums, artistName: artistModel.fetchedArtist!.Name)
                        Divider()
                        SearchArtistShelfSingles(albums: artistModel.fetchedArtist!.Singles, artistName: artistModel.fetchedArtist!.Name)
                    }
                }
            }
            .padding(.top, 1)
        }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 80)
            .background {
                ArtistBackground_component(artwork: artist.Profile_Photo)
            }
    }
}

#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
