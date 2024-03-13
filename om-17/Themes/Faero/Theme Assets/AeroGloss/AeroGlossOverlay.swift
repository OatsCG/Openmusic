//
//  AeroGlossOverlay.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-17.
//

import SwiftUI

struct AeroGlossOverlay: View {
    @Environment(\.colorScheme) private var colorScheme
    var baseCornerRadius: CGFloat = 15
    var padding: CGFloat = 5
    var body: some View {
        if (colorScheme == .dark) {
            AeroGlossOverlayDark(baseCornerRadius: baseCornerRadius, padding: padding)
                .allowsHitTesting(false)
        } else {
            AeroGlossOverlayLight(baseCornerRadius: baseCornerRadius, padding: padding)
                .allowsHitTesting(false)
        }
    }
}

struct AeroGlossOverlayDark: View {
    var baseCornerRadius: CGFloat
    var padding: CGFloat
    var body: some View {
        GeometryReader { geo in
            VStack {
                UnevenRoundedRectangle(topLeadingRadius: baseCornerRadius - padding, bottomLeadingRadius: geo.size.width * 0.2, bottomTrailingRadius: geo.size.width * 0.2, topTrailingRadius: baseCornerRadius - padding)
                    .fill(LinearGradient(colors: [.white.opacity(0.15), .white.opacity(0)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                    .padding(padding)
                    .frame(height: geo.size.height * 0.4)
                Spacer()
            }
        }
    }
}

struct AeroGlossOverlayLight: View {
    var baseCornerRadius: CGFloat
    var padding: CGFloat
    var body: some View {
        GeometryReader { geo in
            VStack {
                UnevenRoundedRectangle(topLeadingRadius: baseCornerRadius - padding, bottomLeadingRadius: geo.size.width * 0.2, bottomTrailingRadius: geo.size.width * 0.2, topTrailingRadius: baseCornerRadius - padding)
                    .fill(LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                    .padding(padding)
                    .frame(height: geo.size.height * 0.4)
                Spacer()
            }
        }
    }
}

#Preview {
    glosstest()
}
