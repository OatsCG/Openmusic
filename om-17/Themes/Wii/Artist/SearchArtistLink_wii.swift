//
//  SearchedArtistLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchArtistLink_wii: View {
    var artist: SearchedArtist
    var body: some View {
        VStack {
            ArtistCookieImageDisplay(imgURL: BuildArtistCookieImageURL(imgID: artist.Profile_Photo, resolution: .tile), Blur: 30, BlurOpacity: 0.6)
            Text(artist.Name)
                .foregroundColor(.primary)
                .customFont(.callout)
            Label(String(artist.Subscribers), systemImage: "person.3.sequence")
                .foregroundColor(.secondary)
                .customFont(.caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 5)
            .background {
                ZStack {
                    Rectangle().fill(.background)
                    TVStaticBackground()
                        .opacity(0.4)
                }
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 2)
            )
    }
}

#Preview {
    HStack {
        SearchArtistLink_wii(artist: SearchedArtist(default: true))
        SearchArtistLink_wii(artist: SearchedArtist(default: true))
    }
    .padding(10)
}
