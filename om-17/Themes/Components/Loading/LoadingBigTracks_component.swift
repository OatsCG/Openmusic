//
//  LoadingBigTracks_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct LoadingBigTracks_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            LoadingBigTracks_classic()
        case "honeycrisp":
            LoadingBigTracks_classic()
        case "wii":
            LoadingBigTracks_classic()
        case "spotty":
            LoadingBigTracks_classic()
        case "faero":
            LoadingBigTracks_classic()
        case "feco":
            LoadingBigTracks_classic()
        case "linen":
            LoadingBigTracks_classic()
        default:
            LoadingBigTracks_classic()
        }
    }
}

#Preview {
    LoadingBigTracks_component()
}
