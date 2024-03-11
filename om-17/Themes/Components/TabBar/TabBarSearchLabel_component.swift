//
//  TabBarSearchLabel_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TabBarSearchLabel_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            TabBarSearchLabel_classic()
        case "honeycrisp":
            TabBarSearchLabel_honeycrisp()
        case "wii":
            TabBarSearchLabel_wii()
        case "spotty":
            TabBarSearchLabel_spotty()
        case "faero":
            TabBarSearchLabel_faero()
        case "feco":
            TabBarSearchLabel_faero()
        default:
            TabBarSearchLabel_classic()
        }
    }
}

struct test__thing: View {
    var body: some View {
        Text("asd")
    }
}

#Preview {
    TabBarSearchLabel_component()
}
