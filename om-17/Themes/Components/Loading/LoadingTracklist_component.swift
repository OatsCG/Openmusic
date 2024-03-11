//
//  LoadingTracklist_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingTracklist_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            LoadingTracklist_classic()
        case "honeycrisp":
            LoadingTracklist_honeycrisp()
        case "wii":
            LoadingTracklist_wii()
        case "spotty":
            LoadingTracklist_spotty()
        case "faero":
            LoadingTracklist_faero()
        case "feco":
            LoadingTracklist_faero()
        default:
            LoadingTracklist_classic()
        }
    }
}

#Preview {
    LoadingTracklist_component()
}
