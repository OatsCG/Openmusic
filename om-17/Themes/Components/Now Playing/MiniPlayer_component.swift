//
//  MiniPlayer_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct MiniPlayer_component: View {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        HStack {
            if (horizontalSizeClass == .regular) {
                Spacer()
            }
            if (Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).width == nil) {
                Group {
                    switch currentTheme {
                    case "classic":
                        MiniPlayer_classic()
                    case "honeycrisp":
                        MiniPlayer_honeycrisp()
                    case "wii":
                        MiniPlayer_wii()
                    case "spotty":
                        MiniPlayer_spotty()
                    case "faero":
                        MiniPlayer_faero()
                    case "feco":
                        MiniPlayer_faero()
                    default:
                        MiniPlayer_classic()
                    }
                }
                .frame(height: Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .aspectRatio(contentMode: .fit)
            } else {
                Group {
                    switch currentTheme {
                    case "classic":
                        MiniPlayer_classic()
                    case "honeycrisp":
                        MiniPlayer_honeycrisp()
                    case "wii":
                        MiniPlayer_wii()
                    case "spotty":
                        MiniPlayer_spotty()
                    case "faero":
                        MiniPlayer_faero()
                    case "feco":
                        MiniPlayer_faero()
                    default:
                        MiniPlayer_classic()
                    }
                }
                .frame(width: Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .aspectRatio(contentMode: .fill)
            }
        }
        
    }
}

#Preview {
    MiniPlayer_component()
}
