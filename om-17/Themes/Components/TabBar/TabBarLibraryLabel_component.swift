//
//  TabBarLibraryLabel_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TabBarLibraryLabel_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Binding var selectionBinding: Int
    var body: some View {
        switch currentTheme {
        case "classic":
            TabBarLibraryLabel_classic()
        case "honeycrisp":
            TabBarLibraryLabel_honeycrisp()
        case "wii":
            TabBarLibraryLabel_wii()
        case "spotty":
            TabBarLibraryLabel_spotty()
        case "faero":
            TabBarLibraryLabel_faero()
        case "feco":
            TabBarLibraryLabel_faero()
        default:
            TabBarLibraryLabel_classic()
        }
    }
}

