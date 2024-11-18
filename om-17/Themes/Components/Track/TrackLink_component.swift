//
//  LibrarySongLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TrackLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var track: any Track
    var body: some View {
        Group {
            switch currentTheme {
            case "classic":
                TrackLink_classic(track: track)
            case "honeycrisp":
                TrackLink_honeycrisp(track: track)
            case "wii":
                TrackLink_wii(track: track)
            case "spotty":
                TrackLink_spotty(track: track)
            case "faero":
                TrackLink_faero(track: track)
            case "feco":
                TrackLink_faero(track: track)
            case "linen":
                TrackLink_linen(track: track)
            default:
                TrackLink_classic(track: track)
            }
        }
            //.aspectRatio(18 / 2, contentMode: .fit)
            .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
            //.containerRelativeFrame(.horizontal, count: TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count, span: TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span, spacing: 8)
    }
}

#Preview {
    TrackLink_component(track: FetchedTrack())
}
