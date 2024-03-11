//
//  QPMultipleLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPMultipleLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var tracks: [any Track]
    var body: some View {
        switch currentTheme {
        case "classic":
            QPMultipleLink_classic(tracks: tracks)
        case "honeycrisp":
            QPMultipleLink_honeycrisp(tracks: tracks)
        case "wii":
            QPMultipleLink_wii(tracks: tracks)
        case "spotty":
            QPMultipleLink_spotty(tracks: tracks)
        case "faero":
            QPMultipleLink_faero(tracks: tracks)
        case "feco":
            QPMultipleLink_faero(tracks: tracks)
        default:
            QPMultipleLink_classic(tracks: tracks)
        }
    }
}

#Preview {
    QPMultipleLink_component(tracks: [FetchedTrack()])
}
