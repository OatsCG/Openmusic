//
//  SearchArtistContentHeader_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct SearchArtistContentHeader_honeycrisp: View {
    var artist: SearchedArtist
    var body: some View {
        ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 8, BlurOpacity: 0.6, cornerRadius: 0)
        HStack {
            Text(artist.Name)
                .customFont(.largeTitle, bold: true)
                .multilineTextAlignment(.leading)
            Spacer()
        }
            .padding(.horizontal, 10)
            .padding(.bottom, 16)
    }
}

#Preview {
    ScrollView {
        SearchArtistContentHeader_honeycrisp(artist: SearchedArtist(default: true))
    }
}
