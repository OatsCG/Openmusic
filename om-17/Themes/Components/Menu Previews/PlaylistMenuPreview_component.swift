//
//  PlaylistMenuPreview_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-31.
//

import SwiftUI

struct PlaylistMenuPreview_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var playlist: Playlist
    var body: some View {
        switch currentTheme {
        case "classic":
            PlaylistMenuPreview_classic(playlist: playlist)
        case "honeycrisp":
            PlaylistMenuPreview_honeycrisp(playlist: playlist)
        case "wii":
            PlaylistMenuPreview_wii(playlist: playlist)
        case "spotty":
            PlaylistMenuPreview_spotty(playlist: playlist)
        case "faero":
            PlaylistMenuPreview_faero(playlist: playlist)
        case "feco":
            PlaylistMenuPreview_faero(playlist: playlist)
        case "linen":
            PlaylistMenuPreview_linen(playlist: playlist)
        default:
            PlaylistMenuPreview_classic(playlist: playlist)
        }
    }
}

#Preview {
    AlbumMenuPreview_component(album: SearchedAlbum())
}

