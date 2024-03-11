//
//  FetchedArtistContentHeader_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct FetchedArtistContentHeader_spotty: View {
    var artist: FetchedArtist
    var body: some View {
        ZStack {
            ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 100, BlurOpacity: 1, cornerRadius: 0)
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
        FetchedArtistContentHeader_spotty(artist: FetchedArtist(default: true))
    }
}
