//
//  LibraryArtistLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct LibraryArtistLink_classic: View {
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
            .background(.thinMaterial)
            .cornerRadius(12)
    }
}

#Preview {
    HStack {
        LibraryArtistLink_classic(artist: SearchedArtist(default: true))
        LibraryArtistLink_classic(artist: SearchedArtist(default: true))
    }
    .padding(10)
}
