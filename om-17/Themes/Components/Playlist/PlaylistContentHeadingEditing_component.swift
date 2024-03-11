//
//  PlaylistContentHeadingEditing_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-16.
//

import SwiftUI

struct PlaylistContentHeadingEditing_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var playlist: StoredPlaylist
    var body: some View {
        switch currentTheme {
        case "classic":
            PlaylistContentHeadingEditing_classic(playlist: playlist)
        case "honeycrisp":
            PlaylistContentHeadingEditing_honeycrisp(playlist: playlist)
        case "wii":
            PlaylistContentHeadingEditing_wii(playlist: playlist)
        case "spotty":
            PlaylistContentHeadingEditing_spotty(playlist: playlist)
        case "faero":
            PlaylistContentHeadingEditing_faero(playlist: playlist)
        case "feco":
            PlaylistContentHeadingEditing_faero(playlist: playlist)
        default:
            PlaylistContentHeadingEditing_classic(playlist: playlist)
        }
    }
}


