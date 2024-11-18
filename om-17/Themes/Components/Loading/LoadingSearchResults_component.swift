//
//  LoadingSearchResults_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingSearchResults_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            LoadingSearchResults_classic()
        case "honeycrisp":
            LoadingSearchResults_honeycrisp()
        case "wii":
            LoadingSearchResults_wii()
        case "spotty":
            LoadingSearchResults_spotty()
        case "faero":
            LoadingSearchResults_faero()
        case "feco":
            LoadingSearchResults_faero()
        case "linen":
            LoadingSearchResults_linen()
        default:
            LoadingSearchResults_classic()
        }
    }
}

#Preview {
    LoadingSearchResults_component()
}
