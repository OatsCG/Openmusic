//
//  AlbumMenuPreview_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct AlbumMenuPreview_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var album: Album
    var body: some View {
        switch currentTheme {
        case "classic":
            AlbumMenuPreview_classic(album: album)
        case "honeycrisp":
            AlbumMenuPreview_honeycrisp(album: album)
        case "wii":
            AlbumMenuPreview_wii(album: album)
        case "spotty":
            AlbumMenuPreview_spotty(album: album)
        case "faero":
            AlbumMenuPreview_faero(album: album)
        case "feco":
            AlbumMenuPreview_faero(album: album)
        default:
            AlbumMenuPreview_classic(album: album)
        }
    }
}

#Preview {
    AlbumMenuPreview_component(album: SearchedAlbum())
}
