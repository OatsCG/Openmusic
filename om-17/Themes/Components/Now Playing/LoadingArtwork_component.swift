//
//  LoadingArtwork_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-31.
//

import SwiftUI

struct LoadingArtwork_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.colorScheme) var colorScheme
    var animated: Bool
    var body: some View {
        Image(colorScheme == .dark ? .loadingDarkClassic : .loadingLightClassic)
            .resizable()
            .scaledToFill()
    }
}

