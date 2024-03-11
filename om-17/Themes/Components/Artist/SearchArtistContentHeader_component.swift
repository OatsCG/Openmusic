//
//  SearchArtistContentHeader_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct SearchArtistContentHeader_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var artist: SearchedArtist
    var body: some View {
        switch currentTheme {
        case "classic":
            SearchArtistContentHeader_classic(artist: artist)
        case "honeycrisp":
            SearchArtistContentHeader_honeycrisp(artist: artist)
        case "wii":
            SearchArtistContentHeader_wii(artist: artist)
        case "spotty":
            SearchArtistContentHeader_spotty(artist: artist)
        case "faero":
            SearchArtistContentHeader_faero(artist: artist)
        case "feco":
            SearchArtistContentHeader_faero(artist: artist)
        default:
            SearchArtistContentHeader_classic(artist: artist)
        }
    }
}


#Preview {
    SearchArtistContentHeader_component(artist: SearchedArtist())
}

#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
