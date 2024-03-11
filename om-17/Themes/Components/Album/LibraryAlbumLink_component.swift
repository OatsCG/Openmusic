//
//  LibraryAlbumLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct LibraryAlbumLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var tracks: [any Track]
    var fill: Bool = true
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                LibraryAlbumLink_classic(tracks: tracks)
            case "honeycrisp":
                LibraryAlbumLink_honeycrisp(tracks: tracks)
            case "wii":
                LibraryAlbumLink_wii(tracks: tracks)
            case "spotty":
                LibraryAlbumLink_spotty(tracks: tracks)
            case "faero":
                LibraryAlbumLink_faero(tracks: tracks)
            case "feco":
                LibraryAlbumLink_faero(tracks: tracks)
            default:
                LibraryAlbumLink_classic(tracks: tracks)
            }
        }
        .frame(width: fill ? nil : SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
    }
}

#Preview {
    LibraryAlbumLink_component(tracks: [FetchedTrack(default: true)])
}
