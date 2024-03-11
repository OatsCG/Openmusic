//
//  ArtistMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct ArtistMenu: View {
    @Environment(\.modelContext) private var context
    var artist: SearchedArtist
    var body: some View {
        NavigationLink(value: SearchArtistContentNPM(artist: artist)) {
            Label("Go to Artist", systemImage: "person.circle")
        }
    }
}
