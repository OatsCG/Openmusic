//
//  AlbumContentButtons_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var text: String
    var subtitle: String?
    var ArtworkID: String
    var body: some View {
        switch currentTheme {
        case "classic":
            AlbumWideButton_classic(text: text, subtitle: subtitle, ArtworkID: ArtworkID)
        case "honeycrisp":
            AlbumWideButton_honeycrisp(text: text, ArtworkID: ArtworkID)
        case "wii":
            AlbumWideButton_wii(text: text, ArtworkID: ArtworkID)
        case "spotty":
            AlbumWideButton_spotty(text: text, ArtworkID: ArtworkID)
        case "faero":
            AlbumWideButton_faero(text: text, ArtworkID: ArtworkID)
        case "feco":
            AlbumWideButton_faero(text: text, ArtworkID: ArtworkID)
        case "linen":
            AlbumWideButton_linen(text: text, ArtworkID: ArtworkID)
        default:
            AlbumWideButton_classic(text: text, ArtworkID: ArtworkID)
        }
    }
}


#Preview {
    AlbumWideButton_component(text: "Play", ArtworkID: SearchedAlbum().Artwork)
}
