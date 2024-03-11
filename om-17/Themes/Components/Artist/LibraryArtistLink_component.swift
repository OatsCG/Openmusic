//
//  LibraryArtistLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct LibraryArtistLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var artist: SearchedArtist
    var body: some View {
        switch currentTheme {
        case "classic":
            LibraryArtistLink_classic(artist: artist)
        case "honeycrisp":
            LibraryArtistLink_honeycrisp(artist: artist)
        case "wii":
            LibraryArtistLink_wii(artist: artist)
        case "spotty":
            LibraryArtistLink_spotty(artist: artist)
        case "faero":
            LibraryArtistLink_faero(artist: artist)
        case "feco":
            LibraryArtistLink_faero(artist: artist)
        default:
            LibraryArtistLink_classic(artist: artist)
        }
    }
}

#Preview {
    LibraryArtistLink_component(artist: SearchedArtist())
}
