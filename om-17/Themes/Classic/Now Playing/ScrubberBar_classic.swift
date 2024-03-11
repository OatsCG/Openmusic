//
//  ScrubberBar_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct ScrubberBar_classic: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDragging: Bool
    @Binding var width: CGFloat
    var currentNormal: CGFloat
    var pressedNormal: CGFloat
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // background bar
                ZStack {
                    Rectangle()
                        .frame(width: width, height: isDragging ? 11 : 7)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(colorScheme == .dark ? 0.4 : 0.2)
                        .blendMode(.overlay)
                    Rectangle()
                        .frame(width: width, height: isDragging ? 11 : 7)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(colorScheme == .dark ? 0.1 : 0.05)
                }
                // current elapsed bar
                HStack {
                    Rectangle()
                        .frame(width: currentNormal, height: isDragging ? 11 : 7)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(self.isDragging ? 0.3 : 0.45)
                    Spacer(minLength: 0)
                }
                // pressed scrubbing bar
                if (self.isDragging) {
                    HStack {
                        Rectangle()
                            .frame(width: pressedNormal, height: isDragging ? 11 : 7)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(0.7)
                        Spacer(minLength: 0)
                    }
                }
            }
                .clipShape(Capsule())
                .onAppear {
                    self.width = geo.size.width
                }
                .onChange(of: geo.size.width) {
                    self.width = geo.size.width
                }
        }
            .frame(height: isDragging ? 11 : 7)
    }
}
