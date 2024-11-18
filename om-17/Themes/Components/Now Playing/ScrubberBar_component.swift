//
//  ScrubberBar_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct ScrubberBar_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Binding var isDragging: Bool
    @Binding var width: CGFloat
    var currentNormal: CGFloat
    var pressedNormal: CGFloat
    var body: some View {
        switch currentTheme {
        case "classic":
            ScrubberBar_classic(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "honeycrisp":
            ScrubberBar_honeycrisp(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "wii":
            ScrubberBar_wii(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "spotty":
            ScrubberBar_spotty(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "faero":
            ScrubberBar_faero(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "feco":
            ScrubberBar_faero(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        case "linen":
            ScrubberBar_linen(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        default:
            ScrubberBar_classic(isDragging: $isDragging, width: $width, currentNormal: currentNormal, pressedNormal: pressedNormal)
        }
    }
}


