//
//  NPBackground_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackground_linen: View {
    @Binding var album: SearchedAlbum?
    @Binding var fullscreen: Bool
    var body: some View {
        ZStack {
            Image(.linenbg)
                .resizable()
                .scaledToFill()
        }
            .ignoresSafeArea()
    }
}


