//
//  SearchedArtistLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchArtistLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var artist: SearchedArtist
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                SearchArtistLink_classic(artist: artist)
            case "honeycrisp":
                SearchArtistLink_honeycrisp(artist: artist)
            case "wii":
                SearchArtistLink_wii(artist: artist)
            case "spotty":
                SearchArtistLink_spotty(artist: artist)
            case "faero":
                SearchArtistLink_faero(artist: artist)
            case "feco":
                SearchArtistLink_faero(artist: artist)
            case "linen":
                SearchArtistLink_linen(artist: artist)
            default:
                SearchArtistLink_classic(artist: artist)
            }
        }
            .frame(width: SearchArtistLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchArtistLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
    }
}

#Preview {
    SearchArtistLink_component(artist: SearchedArtist())
}
