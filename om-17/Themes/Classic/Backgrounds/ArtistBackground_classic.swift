//
//  ArtistBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct ArtistBackground_classic: View {
    var artwork: String
    var body: some View {
        ZStack {
            Color(.systemFill).opacity(0.3)
            ArtistPageBGDisplay(ArtworkID: artwork, Resolution: .background)
                .blur(radius: 100, opaque: true)
                .opacity(0.2)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    ArtistBackground_classic(artwork: SearchedArtist(default: true).Profile_Photo)
}
