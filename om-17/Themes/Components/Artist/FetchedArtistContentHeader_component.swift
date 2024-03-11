//
//  FetchedArtistContentHeader_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct FetchedArtistContentHeader_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var artist: FetchedArtist
    var body: some View {
        switch currentTheme {
        case "classic":
            FetchedArtistContentHeader_classic(artist: artist)
        case "honeycrisp":
            FetchedArtistContentHeader_honeycrisp(artist: artist)
        case "wii":
            FetchedArtistContentHeader_wii(artist: artist)
        case "spotty":
            FetchedArtistContentHeader_spotty(artist: artist)
        case "faero":
            FetchedArtistContentHeader_faero(artist: artist)
        case "feco":
            FetchedArtistContentHeader_faero(artist: artist)
        default:
            FetchedArtistContentHeader_classic(artist: artist)
        }
    }
}


#Preview {
    FetchedArtistContentHeader_component(artist: FetchedArtist_default())
}

#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
