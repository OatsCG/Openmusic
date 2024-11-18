//
//  SearchedAlbumLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var album: SearchedAlbum
    var fill: Bool = false
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                SearchAlbumLink_classic(album: album)
            case "honeycrisp":
                SearchAlbumLink_honeycrisp(album: album)
            case "wii":
                SearchAlbumLink_wii(album: album)
            case "spotty":
                SearchAlbumLink_spotty(album: album)
            case "faero":
                SearchAlbumLink_faero(album: album)
            case "feco":
                SearchAlbumLink_faero(album: album)
            case "linen":
                SearchAlbumLink_linen(album: album)
            default:
                SearchAlbumLink_classic(album: album)
            }
        }
        .frame(width: fill ? nil : SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
    }
}

struct SearchAlbumLinkBig_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var album: SearchedAlbum
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                SearchAlbumLink_classic(album: album)
            case "honeycrisp":
                SearchAlbumLink_honeycrisp(album: album)
            case "wii":
                SearchAlbumLink_wii(album: album)
            case "spotty":
                SearchAlbumLink_spotty(album: album)
            case "faero":
                SearchAlbumLink_faero(album: album)
            case "feco":
                SearchAlbumLink_faero(album: album)
            case "linen":
                SearchAlbumLink_linen(album: album)
            default:
                SearchAlbumLink_classic(album: album)
            }
        }
        .frame(width: SearchAlbumLinkBig_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
    }
}

#Preview {
    ScrollView(.vertical) {
        VStack {
            ScrollView(.horizontal) {
                VStackWrapped(columns: 2) {
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                    SearchAlbumLink_component(album: SearchedAlbum(default: true))
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SearchAlbumLink_component(album: SearchedAlbum(default: true))
}
