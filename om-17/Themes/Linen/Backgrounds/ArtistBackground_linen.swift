//
//  ArtistBackground_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct ArtistBackground_linen: View {
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
    ArtistBackground_linen(artwork: SearchedArtist(default: true).Profile_Photo)
}
