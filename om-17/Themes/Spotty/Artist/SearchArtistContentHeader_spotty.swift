//
//  SearchArtistContentHeader_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct SearchArtistContentHeader_spotty: View {
    var artist: SearchedArtist
    var body: some View {
        ZStack {
            ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 400, BlurOpacity: 1, cornerRadius: 0)
            VStack {
                Spacer()
                HStack {
                    Text(artist.Name)
                        .customFont(.largeTitle, bold: true)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }
            }
                .padding(10)
        }
            .padding(.bottom, 16)
    }
}

#Preview {
    ScrollView {
        SearchArtistContentHeader_spotty(artist: SearchedArtist(default: true))
    }
}
