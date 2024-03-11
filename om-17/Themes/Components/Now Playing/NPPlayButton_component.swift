//
//  NPPlayButton_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPPlayButton_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            NPPlayButton_classic()
        case "honeycrisp":
            NPPlayButton_honeycrisp()
        case "wii":
            NPPlayButton_wii()
        case "spotty":
            NPPlayButton_spotty()
        case "faero":
            NPPlayButton_faero()
        case "feco":
            NPPlayButton_faero()
        default:
            NPPlayButton_classic()
        }
    }
}

#Preview {
    NPPlayButton_component()
}
