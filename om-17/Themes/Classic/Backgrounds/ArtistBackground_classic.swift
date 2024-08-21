//
//  ArtistBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct ArtistBackground_classic: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color(red: 0.05, green: 0.05, blue: 0.05)
            } else {
                Color(.white)
            }
            ArtistPageBGDisplay(ArtworkID: artwork, Resolution: .background)
                .blur(radius: 100, opaque: true)
                .opacity(0.2)
                .drawingGroup()
        }
            .ignoresSafeArea()
    }
}

#Preview {
    ArtistBackground_classic(artwork: SearchedArtist(default: true).Profile_Photo)
}
