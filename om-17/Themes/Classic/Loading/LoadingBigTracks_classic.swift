//
//  LoadingBigTracks_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct LoadingBigTracks_classic: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var gradientStop: CGFloat = 0
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                ForEach(1...20, id: \.self) { _ in
                    HStack {
                        RoundedRectangle(cornerRadius: 8).fill(.foreground.opacity(0.05))
                            .aspectRatio(1, contentMode: .fit)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.2))
                                .frame(width: 150, height: 16)
                            RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.1))
                                .frame(width: 60, height: 14)
                        }
                        Spacer()
                        RoundedRectangle(cornerRadius: 4).fill(.primary.opacity(0.1))
                            .frame(width: 40, height: 16)
                    }
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .padding([.vertical, .leading], 5)
                        .padding(.trailing, 10)
                        .background(.foreground.opacity(0.1))
                        .overlay {
                            LinearGradient(
                                gradient: Gradient(
                                    stops: [
                                        Gradient.Stop(
                                            color: .clear,
                                            location: 0
                                        ),
                                        Gradient.Stop(
                                            color: .primary.opacity(0.06),
                                            location: 0.5
                                        ),
                                        Gradient.Stop(
                                            color: .clear,
                                            location: 1
                                        )
                                    ]
                                ),
                                startPoint: UnitPoint(x: -1 + gradientStop, y: -1 + gradientStop),
                                endPoint: UnitPoint(x: 0 + gradientStop, y: 0 + gradientStop))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
                        .contentShape(Rectangle())
                        .clipped()
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                                gradientStop = 2
                            }
                        }
                }
            }
                //.safeAreaPadding(.horizontal, 10)
        }
    }
}

#Preview {
    LoadingBigTracks_classic()
}
