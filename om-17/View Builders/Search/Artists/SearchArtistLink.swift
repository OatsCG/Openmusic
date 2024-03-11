//
//  ArtistDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI

struct SearchArtistLink: View {
    var artist: SearchedArtist
    var body: some View {
        NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
            SearchArtistLink_component(artist: artist)
        }
            .contextMenu {
                ArtistMenu(artist: artist)
            }
    }
}

#Preview {
    ExplorePage(exploreNSPath: .constant(NavigationPath()))
}
