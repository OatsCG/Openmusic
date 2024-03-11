//
//  MiniPlayer_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct MiniPlayer_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            MiniPlayer_classic()
        case "honeycrisp":
            MiniPlayer_honeycrisp()
        case "wii":
            MiniPlayer_wii()
        case "spotty":
            MiniPlayer_spotty()
        case "faero":
            MiniPlayer_faero()
        case "feco":
            MiniPlayer_faero()
        default:
            MiniPlayer_classic()
        }
    }
}

#Preview {
    MiniPlayer_component()
}
