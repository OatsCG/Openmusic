//
//  AlbumBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_classic: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color(red: 0.05, green: 0.05, blue: 0.05)
            } else {
                Color(.white)
            }
            AlbumBackground(ArtworkID: artwork, blur: 60, light_opacity: 0.15, dark_opacity: 0.15, spin: false, material: false)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    AlbumBackground_classic(artwork: SearchedAlbum(default: true).Artwork)
}
