//
//  DefaultArtwork_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-05.
//

import SwiftUI

struct DefaultArtwork_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var animated: Bool
    var body: some View {
        switch currentTheme {
        case "classic":
            DefaultArtwork_classic(animated: animated)
        case "honeycrisp":
            DefaultArtwork_honeycrisp(animated: animated)
        case "wii":
            DefaultArtwork_wii(animated: animated)
        case "spotty":
            DefaultArtwork_spotty(animated: animated)
        case "faero":
            DefaultArtwork_faero(animated: animated)
        case "feco":
            DefaultArtwork_faero(animated: animated)
        case "linen":
            DefaultArtwork_linen(animated: animated)
        default:
            DefaultArtwork_classic(animated: animated)
        }
    }
}

#Preview {
    DefaultArtwork_component(animated: true)
}
