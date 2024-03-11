//
//  ScrubberBar_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI

struct ScrubberBar_spotty: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDragging: Bool
    @Binding var width: CGFloat
    var currentNormal: CGFloat
    var pressedNormal: CGFloat
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Group {
                    // background bar
                    ZStack {
                        Rectangle()
                            .frame(width: width, height: 4)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(colorScheme == .dark ? 0.4 : 0.2)
                            .blendMode(.overlay)
                        Rectangle()
                            .frame(width: width, height: 4)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(colorScheme == .dark ? 0.1 : 0.05)
                    }
                    // current elapsed bar
                    HStack {
                        Rectangle()
                            .frame(width: currentNormal, height: 4)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(self.isDragging ? 0.3 : 0.45)
                        Spacer(minLength: 0)
                    }
                    // pressed scrubbing bar
                    if (self.isDragging) {
                        HStack {
                            Rectangle()
                                .frame(width: pressedNormal, height: 4)
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .opacity(0.7)
                            Spacer(minLength: 0)
                        }
                    }
                }
                .clipShape(Capsule())
                HStack(alignment: .center) {
                    Circle().fill(.white)
                        .frame(width: 10, height: 10)
                        .position(x: isDragging ? pressedNormal : currentNormal, y: 5)
                }
            }
                .onAppear {
                    self.width = geo.size.width
                }
                .onChange(of: geo.size.width) {
                    self.width = geo.size.width
                }
        }
            .frame(height: 10)
    }
}
