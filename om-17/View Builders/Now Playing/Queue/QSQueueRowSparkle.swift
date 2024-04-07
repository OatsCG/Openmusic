//
//  QSQueueRowSparkle.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

struct QSQueueRowSparkle: View {
    @Environment(FontManager.self) private var fontManager
    @State var gradientRotate: CGFloat = 0
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "sparkles")
                .customFont(fontManager, .title3)
                .overlay {
                    LinearGradient(
                        colors: [
                            .pink,
                            .blue
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .rotationEffect(.degrees(gradientRotate))
                        .mask {
                            Image(systemName: "sparkles")
                                .customFont(fontManager, .title3)
                        }
                }
                .padding(.trailing, 10)
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        gradientRotate = 360
                    }
                }
        }
        .foregroundStyle(.secondary)
        .opacity(0.6)
    }
}

#Preview {
    QSQueueRowSparkle()
        .scaleEffect(5)
}
