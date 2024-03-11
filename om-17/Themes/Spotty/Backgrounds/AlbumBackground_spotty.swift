//
//  AlbumBackground_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_spotty: View {
    var artwork: String
    var body: some View {
        VStack {
            Rectangle().fill(Color(white: 0.07))
        }
            .ignoresSafeArea()
    }
}

#Preview {
    AlbumBackground_spotty(artwork: SearchedAlbum(default: true).Artwork)
}
