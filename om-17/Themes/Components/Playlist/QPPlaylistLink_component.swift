//
//  QPPlaylistLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI

struct QPPlaylistLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var playlist: StoredPlaylist
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                QPPlaylistLink_classic(playlist: playlist)
            case "honeycrisp":
                QPPlaylistLink_honeycrisp(playlist: playlist)
            case "wii":
                QPPlaylistLink_wii(playlist: playlist)
            case "spotty":
                QPPlaylistLink_spotty(playlist: playlist)
            case "faero":
                QPPlaylistLink_faero(playlist: playlist)
            case "feco":
                QPPlaylistLink_faero(playlist: playlist)
            default:
                QPPlaylistLink_classic(playlist: playlist)
            }
        }
            .aspectRatio(CGFloat(QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / QPMultiple_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fill)
    }
}
