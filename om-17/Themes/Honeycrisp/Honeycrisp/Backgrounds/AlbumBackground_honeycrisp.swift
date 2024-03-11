//
//  AlbumBackground_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_honeycrisp: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        VStack {
            if (colorScheme == .dark) {
                Color(.black)
            } else {
                Color(.white)
            }
        }
            .ignoresSafeArea()
    }
}

#Preview {
    AlbumBackground_honeycrisp(artwork: SearchedAlbum(default: true).Artwork)
}
