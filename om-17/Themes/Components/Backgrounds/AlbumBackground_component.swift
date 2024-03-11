//
//  AlbumBackground_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct AlbumBackground_component: View {
    var artwork: String
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            AlbumBackground_classic(artwork: artwork)
        case "honeycrisp":
            AlbumBackground_honeycrisp(artwork: artwork)
        case "wii":
            AlbumBackground_wii(artwork: artwork)
        case "spotty":
            AlbumBackground_spotty(artwork: artwork)
        case "faero":
            AlbumBackground_faero(artwork: artwork)
        case "feco":
            AlbumBackground_feco(artwork: artwork)
        default:
            AlbumBackground_classic(artwork: artwork)
        }
    }
}

#Preview {
    AlbumBackground_component(artwork: SearchedAlbum().Artwork)
}
