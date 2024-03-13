//
//  AeroGlossBG.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-17.
//

import SwiftUI

struct AeroGlossBG: View {
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = 15
    var body: some View {
        if (colorScheme == .dark) {
            AeroGlossBGDark(cornerRadius: cornerRadius)
        } else {
            AeroGlossBGLight(cornerRadius: cornerRadius)
        }
    }
}

struct AeroGlossBGDark: View {
    var cornerRadius: CGFloat
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    Rectangle().fill(LinearGradient(
                        colors: [
                            .white.opacity(0.13),
                            .white.opacity(0.16),
                            .white.opacity(0.16),
                            .white.opacity(0.12),
                            .white.opacity(0.12),
                            .white.opacity(0.12),
                            .white.opacity(0.2)
                        ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
        }
    }
}

struct AeroGlossBGLight: View {
    var cornerRadius: CGFloat
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    Rectangle().fill(LinearGradient(
                        colors: [
                            .black.opacity(0.1),
                            .black.opacity(0.08),
                            .black.opacity(0.08),
                            .black.opacity(0.1),
                            .black.opacity(0.1),
                            .black.opacity(0.1),
                            .black.opacity(0.08)
                        ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
        }
    }
}

#Preview {
    glosstest()
}
