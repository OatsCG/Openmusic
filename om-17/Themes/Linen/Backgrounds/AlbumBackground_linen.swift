//
//  AlbumBackground_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_linen: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        ZStack {
            Image(.linenbg)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    AlbumBackground_linen(artwork: SearchedAlbum(default: true).Artwork)
}
