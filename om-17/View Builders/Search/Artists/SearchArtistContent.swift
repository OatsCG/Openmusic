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
                if let fetchedArtist = artistModel.fetchedArtist {
                    FetchedArtistContentHeader_component(artist: fetchedArtist)
                    Spacer()
                    VStack(spacing: 20) {
                        if (!fetchedArtist.Tracks.isEmpty) {
                            SearchArtistShelfTracks(tracks: fetchedArtist.Tracks, artistName: fetchedArtist.Name)
                            Divider()
                        }
                        SearchArtistShelfAlbums(albums: fetchedArtist.Albums, artistName: fetchedArtist.Name)
                        if (!fetchedArtist.Singles.isEmpty) {
                            Divider()
                            SearchArtistShelfSingles(albums: fetchedArtist.Singles, artistName: fetchedArtist.Name)
                        }
                    }
                } else {
                    SearchArtistContentHeader_component(artist: artist)
                    Spacer()
                    LoadingSearchResults_component()
                        .task {
                            artistModel.runSearch(artistID: artist.ArtistID)
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
