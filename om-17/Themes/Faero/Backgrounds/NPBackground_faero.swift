//
//  NPBackground_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackground_faero: View {
    @Environment(\.colorScheme) private var colorScheme
    var album: SearchedAlbum?
    @Binding var fullscreen: Bool
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            AeroBG().opacity(0.7)
        }
    }
}


