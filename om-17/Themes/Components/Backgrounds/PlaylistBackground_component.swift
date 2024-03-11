//
//  PlaylistBackground_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct PlaylistBackground_component: View {
    var playlist: Playlist
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            PlaylistBackground_classic(playlist: playlist)
        case "honeycrisp":
            PlaylistBackground_honeycrisp(playlist: playlist)
        case "wii":
            PlaylistBackground_wii(playlist: playlist)
        case "spotty":
            PlaylistBackground_spotty(playlist: playlist)
        case "faero":
            PlaylistBackground_faero(playlist: playlist)
        case "feco":
            PlaylistBackground_feco(playlist: playlist)
        default:
            PlaylistBackground_classic(playlist: playlist)
        }
    }
}

//#Preview {
//    PlaylistBackground_component(playlistID: UUID())
//}
