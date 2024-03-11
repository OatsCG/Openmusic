//
//  PlaylistContentHeading_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-05.
//

import SwiftUI

struct PlaylistContentHeading_component: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var playlist: Playlist
    var body: some View {
        if (horizontalSizeClass == .regular || verticalSizeClass == .compact) {
            switch currentTheme {
            case "classic":
                PlaylistContentHeadingBig_classic(playlist: playlist)
            case "honeycrisp":
                PlaylistContentHeadingBig_honeycrisp(playlist: playlist)
            case "wii":
                PlaylistContentHeadingBig_wii(playlist: playlist)
            case "spotty":
                PlaylistContentHeadingBig_spotty(playlist: playlist)
            case "faero":
                PlaylistContentHeadingBig_faero(playlist: playlist)
            case "feco":
                PlaylistContentHeadingBig_faero(playlist: playlist)
            default:
                PlaylistContentHeadingBig_classic(playlist: playlist)
            }
        } else {
            switch currentTheme {
            case "classic":
                PlaylistContentHeading_classic(playlist: playlist)
            case "honeycrisp":
                PlaylistContentHeading_honeycrisp(playlist: playlist)
            case "wii":
                PlaylistContentHeading_wii(playlist: playlist)
            case "spotty":
                PlaylistContentHeading_spotty(playlist: playlist)
            case "faero":
                PlaylistContentHeading_faero(playlist: playlist)
            case "feco":
                PlaylistContentHeading_faero(playlist: playlist)
            default:
                PlaylistContentHeading_classic(playlist: playlist)
            }
        }
    }
}


#Preview {
    PlaylistContentHeading_component(playlist: SearchedPlaylist_default())
}
