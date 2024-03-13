//
//  AlbumBackground_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_faero: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            AeroBG().opacity(0.7)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AlbumBackground_faero(artwork: SearchedAlbum(default: true).Artwork)
}
