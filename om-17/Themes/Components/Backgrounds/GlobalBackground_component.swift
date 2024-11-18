//
//  Global.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-03.
//

import SwiftUI

struct GlobalBackground_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            GlobalBackground_classic()
        case "honeycrisp":
            GlobalBackground_honeycrisp()
        case "wii":
            GlobalBackground_wii()
        case "spotty":
            GlobalBackground_spotty()
        case "faero":
            GlobalBackground_faero()
        case "feco":
            GlobalBackground_feco()
        case "linen":
            GlobalBackground_linen()
        default:
            GlobalBackground_classic()
        }
    }
}

#Preview {
    GlobalBackground_component()
}

