//
//  AlbumBackground_feco.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-18.
//

import SwiftUI

struct AlbumBackground_feco: View {
    @Environment(\.colorScheme) private var colorScheme
    var artwork: String
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            AeroBG(colorDark: .green, colorLight: .blue).opacity(0.7)
                .ignoresSafeArea()
        }
    }
}

