//
//  SearchArtistContentHeader_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct SearchArtistContentHeader_faero: View {
    @Environment(FontManager.self) private var fontManager
    var artist: SearchedArtist
    var body: some View {
        ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 8, BlurOpacity: 0.6, cornerRadius: 12)
            .overlay {
                AeroGlossOverlay(baseCornerRadius: 12, padding: 5)
            }
        HStack {
            Text(artist.Name)
                .customFont(fontManager, .largeTitle, bold: true)
                .multilineTextAlignment(.leading)
            Spacer()
        }
            .padding(.horizontal, 10)
            .padding(.bottom, 16)
    }
}

#Preview {
    ScrollView {
        SearchArtistContentHeader_faero(artist: SearchedArtist(default: true))
    }
}
