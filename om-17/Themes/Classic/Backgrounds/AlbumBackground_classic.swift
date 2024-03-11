//
//  AlbumBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_classic: View {
    var artwork: String
    var body: some View {
        ZStack {
            Color(.systemFill).opacity(0.3)
            AlbumBackground(ArtworkID: artwork, blur: 60, light_opacity: 0.15, dark_opacity: 0.15, spin: false, material: false)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    AlbumBackground_classic(artwork: SearchedAlbum(default: true).Artwork)
}
