//
//  NPBackground_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackground_honeycrisp: View {
    @Binding var album: SearchedAlbum?
    @Binding var fullscreen: Bool
    var body: some View {
        AlbumBackground(ArtworkID: album?.Artwork, blur: 60, light_opacity: fullscreen ? 0.6 : 0.5, dark_opacity: fullscreen ? 0.75 : 0.5, spin: UserDefaults.standard.bool(forKey: "themeAnimations"))
    }
}
