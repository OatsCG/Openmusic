//
//  TrackSpeakerIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-29.
//

import SwiftUI

struct TrackSpeakerIcon: View {
    @State var rotation: CGFloat = 0
    
    var body: some View {
        Image(systemName: "speaker.wave.2")
            .font(.callout .bold() .monospaced())
            .foregroundColor(.secondary)
            .overlay {
                Rectangle().fill(AngularGradient(colors: [
                    .red,
                    .orange,
                    .yellow,
                    .green,
                    .blue,
                    .indigo,
                    .purple,
                    .red
                ], center: UnitPoint(x: 0.3, y: 0.5), angle: .degrees(rotation))).opacity(0.5)
            }
            .mask {
                Image(systemName: "speaker.wave.2")
                    .font(.callout .bold() .monospaced())
            }
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        
    }
}

#Preview {
    VStack {
        Image(systemName: "speaker.wave.2")
            .foregroundColor(.secondary)
            .font(.callout .bold() .monospaced())
        TrackSpeakerIcon()
    }
        .scaleEffect(5)
}
