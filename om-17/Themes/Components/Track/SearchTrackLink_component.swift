//
//  SearchedTrackLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchTrackLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var track: any Track
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                SearchTrackLink_classic(track: track)
            case "honeycrisp":
                SearchTrackLink_honeycrisp(track: track)
            case "wii":
                SearchTrackLink_wii(track: track)
            case "spotty":
                SearchTrackLink_spotty(track: track)
            case "faero":
                SearchTrackLink_faero(track: track)
            case "feco":
                SearchTrackLink_faero(track: track)
            default:
                SearchTrackLink_classic(track: track)
            }
        }
            .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
    }
}

#Preview {
    ScrollView(.horizontal) {
        HStack {
            SearchTrackLink_component(track: FetchedTrack(default: true))
            SearchTrackLink_component(track: FetchedTrack())
            SearchTrackLink_component(track: FetchedTrack())
        }
    }
}
