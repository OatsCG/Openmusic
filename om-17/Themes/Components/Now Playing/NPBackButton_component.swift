//
//  NPBackButton_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct NPBackButton_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    var body: some View {
        switch currentTheme {
        case "classic":
            NPBackButton_classic()
        case "honeycrisp":
            NPBackButton_honeycrisp()
        case "wii":
            NPBackButton_wii()
        case "spotty":
            NPBackButton_spotty()
        case "faero":
            NPBackButton_faero()
        case "feco":
            NPBackButton_faero()
        default:
            NPBackButton_classic()
        }
    }
}
