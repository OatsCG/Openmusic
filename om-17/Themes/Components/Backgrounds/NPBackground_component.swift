//
//  NPBackground_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackground_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Binding var album: SearchedAlbum?
    @Binding var fullscreen: Bool
    var body: some View {
        switch currentTheme {
        case "classic":
            NPBackground_classic(album: $album, fullscreen: $fullscreen)
        case "honeycrisp":
            NPBackground_honeycrisp(album: $album, fullscreen: $fullscreen)
        case "wii":
            NPBackground_wii(album: $album, fullscreen: $fullscreen)
        case "spotty":
            NPBackground_spotty(album: $album, fullscreen: $fullscreen)
        case "faero":
            NPBackground_faero(album: $album, fullscreen: $fullscreen)
        case "feco":
            NPBackground_feco(album: $album, fullscreen: $fullscreen)
        case "linen":
            NPBackground_linen(album: $album, fullscreen: $fullscreen)
        default:
            NPBackground_classic(album: $album, fullscreen: $fullscreen)
        }
    }
}
