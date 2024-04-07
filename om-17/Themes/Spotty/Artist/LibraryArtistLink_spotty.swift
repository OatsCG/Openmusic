//
//  LibraryArtistLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct LibraryArtistLink_spotty: View {
    @Environment(FontManager.self) private var fontManager
    var artist: SearchedArtist
    var body: some View {
        VStack {
            ArtistCookieImageDisplay(imgURL: BuildArtistCookieImageURL(imgID: artist.Profile_Photo, resolution: .tile), Blur: 0, BlurOpacity: 0)
            Text(artist.Name)
                .foregroundColor(.primary)
                .customFont(fontManager, .callout)
            Label(String(artist.Subscribers), systemImage: "person.3.sequence")
                .foregroundColor(.secondary)
                .customFont(fontManager, .caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 8)
            .cornerRadius(12)
    }
}

#Preview {
    HStack {
        LibraryArtistLink_spotty(artist: SearchedArtist(default: true))
        LibraryArtistLink_spotty(artist: SearchedArtist(default: true))
    }
    .padding(10)
}
