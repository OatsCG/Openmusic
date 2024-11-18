//
//  LoadingExplore_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct LoadingExplore_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            LoadingExplore_classic()
        case "honeycrisp":
            LoadingExplore_classic()
        case "wii":
            LoadingExplore_classic()
        case "spotty":
            LoadingExplore_classic()
        case "faero":
            LoadingExplore_classic()
        case "feco":
            LoadingExplore_classic()
        case "linen":
            LoadingExplore_classic()
        default:
            LoadingExplore_classic()
        }
    }
}

#Preview {
    LoadingExplore_component()
}
