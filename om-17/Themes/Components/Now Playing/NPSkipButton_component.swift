//
//  NPSkipButton_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPSkipButton_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            NPSkipButton_classic()
        case "honeycrisp":
            NPSkipButton_honeycrisp()
        case "wii":
            NPSkipButton_wii()
        case "spotty":
            NPSkipButton_spotty()
        case "faero":
            NPSkipButton_faero()
        case "feco":
            NPSkipButton_faero()
        case "linen":
            NPSkipButton_linen()
        default:
            NPSkipButton_classic()
        }
    }
}

#Preview {
    NPSkipButton_component()
}
