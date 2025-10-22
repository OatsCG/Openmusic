//
//  PlaylistBackground.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI

struct PlaylistBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var playlist: Playlist
    var blur: Double
    var light_opacity: Double
    var dark_opacity: Double
    var spin: Bool
    var saturate: Bool = false
    var material: Bool = true
    @State var isRotating = Double.random(in: 0..<360)
    
    var body: some View {
        ZStack {
            if material {
                Rectangle().fill(.ultraThinMaterial)
                    .overlay {
                        PlaylistArtBGDisplay(playlist: playlist)
                            .blur(radius: blur, opaque: true)
                            .saturation(saturate ? 2 : 1.3)
                            .opacity(colorScheme == .dark ? dark_opacity : light_opacity)
                            .scaleEffect(1.4)
                            .rotationEffect(.degrees(isRotating))
                            .drawingGroup()
                    }
                    .clipped()
            } else {
                Rectangle().fill(Color.clear)
                    .overlay {
                        PlaylistArtBGDisplay(playlist: playlist)
                            .blur(radius: blur, opaque: true)
                            .saturation(saturate ? 2 : 1.3)
                            .opacity(colorScheme == .dark ? dark_opacity : light_opacity)
                            .scaleEffect(1.4)
                            .rotationEffect(.degrees(isRotating))
                            .drawingGroup()
                    }
                    .clipped()
            }
        }
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .onAppear {
                if spin {
                    withAnimation(.linear(duration: 33)
                        .repeatForever(autoreverses: false)) {
                            isRotating = isRotating + 360
                        }
                }
            }
    }
}
