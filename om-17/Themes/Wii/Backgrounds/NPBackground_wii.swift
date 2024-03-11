//
//  NPBackground_wii.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackground_wii: View {
    var album: SearchedAlbum?
    @Binding var fullscreen: Bool
    var body: some View {
        Image(.wiibutton)
            .resizable()
            .scaledToFill()
            .opacity(0.6)
            .ignoresSafeArea()
        //Color.secondary.opacity(0.3)
        //AlbumBackground(ArtworkID: album?.Artwork, blur: 60, light_opacity: fullscreen ? 0.6 : 0.5, dark_opacity: fullscreen ? 0.75 : 0.5, spin: true)
    }
}

