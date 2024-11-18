//
//  TabbarBackground.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct TabbarBackground_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Binding var tabbarHeight: CGFloat
    var body: some View {
        switch currentTheme {
        case "classic":
            TabbarBackground_classic(tabbarHeight: $tabbarHeight)
        case "honeycrisp":
            TabbarBackground_honeycrisp(tabbarHeight: $tabbarHeight)
        case "wii":
            TabbarBackground_wii(tabbarHeight: $tabbarHeight)
        case "spotty":
            TabbarBackground_spotty(tabbarHeight: $tabbarHeight)
        case "faero":
            TabbarBackground_faero(tabbarHeight: $tabbarHeight)
        case "feco":
            TabbarBackground_faero(tabbarHeight: $tabbarHeight)
        case "linen":
            TabbarBackground_linen(tabbarHeight: $tabbarHeight)
        default:
            TabbarBackground_classic(tabbarHeight: $tabbarHeight)
        }
    }
}
