//
//  ArtistBackground_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct ArtistBackground_honeycrisp: View {
    var artwork: String
    @Environment(\.colorScheme) private var colorScheme
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
    ArtistBackground_component(artwork: SearchedArtist(default: true).Profile_Photo)
}
