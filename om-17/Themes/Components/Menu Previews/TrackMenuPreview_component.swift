//
//  TrackMenuPreview_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct TrackMenuPreview_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var track: any Track
    var body: some View {
        switch currentTheme {
        case "classic":
            TrackMenuPreview_classic(track: track)
        case "honeycrisp":
            TrackMenuPreview_honeycrisp(track: track)
        case "wii":
            TrackMenuPreview_wii(track: track)
        case "spotty":
            TrackMenuPreview_spotty(track: track)
        case "faero":
            TrackMenuPreview_faero(track: track)
        case "feco":
            TrackMenuPreview_faero(track: track)
        case "linen":
            TrackMenuPreview_linen(track: track)
        default:
            TrackMenuPreview_classic(track: track)
        }
    }
}

#Preview {
    TrackMenuPreview_component(track: FetchedTrack())
}
