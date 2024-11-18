//
//  AlbumContentHeading_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumContentHeading_component: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var album: SearchedAlbum
    var tracks: [any Track]?
    var body: some View {
        if (horizontalSizeClass == .regular || verticalSizeClass == .compact) {
            switch currentTheme {
            case "classic":
                AlbumContentHeadingBig_classic(album: album, tracks: tracks)
            case "honeycrisp":
                AlbumContentHeadingBig_honeycrisp(album: album, tracks: tracks)
            case "wii":
                AlbumContentHeadingBig_wii(album: album, tracks: tracks)
            case "spotty":
                AlbumContentHeadingBig_spotty(album: album, tracks: tracks)
            case "faero":
                AlbumContentHeadingBig_faero(album: album, tracks: tracks)
            case "feco":
                AlbumContentHeadingBig_faero(album: album, tracks: tracks)
            case "linen":
                AlbumContentHeadingBig_linen(album: album, tracks: tracks)
            default:
                AlbumContentHeadingBig_classic(album: album, tracks: tracks)
            }
        } else {
            switch currentTheme {
            case "classic":
                AlbumContentHeading_classic(album: album, tracks: tracks)
            case "honeycrisp":
                AlbumContentHeading_honeycrisp(album: album, tracks: tracks)
            case "wii":
                AlbumContentHeading_wii(album: album, tracks: tracks)
            case "spotty":
                AlbumContentHeading_spotty(album: album, tracks: tracks)
            case "faero":
                AlbumContentHeading_faero(album: album, tracks: tracks)
            case "feco":
                AlbumContentHeading_faero(album: album, tracks: tracks)
            case "linen":
                AlbumContentHeading_linen(album: album, tracks: tracks)
            default:
                AlbumContentHeading_classic(album: album, tracks: tracks)
            }
        }
    }
}

#Preview {
    AlbumContentHeading_component(album: SearchedAlbum())
}
