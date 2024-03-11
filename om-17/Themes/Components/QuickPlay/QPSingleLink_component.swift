//
//  QPSingleLink_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-14.
//

import SwiftUI

struct QPSingleLink_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var track: any Track
    var body: some View {
        switch currentTheme {
        case "classic":
            QPSingleLink_classic(track: track)
        case "honeycrisp":
            QPSingleLink_honeycrisp(track: track)
        case "wii":
            QPSingleLink_wii(track: track)
        case "spotty":
            QPSingleLink_spotty(track: track)
        case "faero":
            QPSingleLink_faero(track: track)
        case "feco":
            QPSingleLink_faero(track: track)
        default:
            QPSingleLink_classic(track: track)
        }
    }
}

#Preview {
    QPSingleLink_component(track: FetchedTrack())
}
