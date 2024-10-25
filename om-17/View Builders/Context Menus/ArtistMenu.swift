//
//  ArtistMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct ArtistMenu: View {
    var artist: SearchedArtist // dont have to optional this
    var body: some View {
        NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
            Label("Go to Artist", systemImage: "person.circle")
        }
    }
}
