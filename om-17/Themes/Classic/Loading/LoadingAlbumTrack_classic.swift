//
//  LoadingAlbumTrack_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingAlbumTrack_classic: View {
    @State var gradientStop: CGFloat = 0
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.1))
                .frame(width: 15, height: 20)
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.2))
                    .frame(width: 200, height: 10)
                RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.1))
                    .frame(width: 40, height: 10)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 2).fill(.primary.opacity(0.1))
                .frame(width: 20, height: 20)
        }
            .padding([.top, .bottom], 10)
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
            .contentShape(Rectangle())
            .opacity(0.8)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                    gradientStop = 2
                }
            }
    }
}

#Preview {
    ScrollView {
        VStack {
            LoadingAlbumTrack_classic()
            LoadingAlbumTrack_classic()
        }
    }
}
