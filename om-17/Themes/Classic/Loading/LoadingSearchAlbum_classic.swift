//
//  LoadingSearchAlbum_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingSearchAlbum_classic: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var gradientStop: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            RoundedRectangle(cornerRadius: 6).fill(.foreground.opacity(0.05))
                .aspectRatio(1, contentMode: .fill)
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 2).fill(.foreground.opacity(0.1))
                    .frame(width: 120)
                RoundedRectangle(cornerRadius: 2).fill(.foreground.opacity(0.1))
                    .frame(width: 90)
            }
        }
            .padding(.all, 4)
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
            .cornerRadius(8)
            .frame(width: SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                    gradientStop = 2
                }
            }
    }
}

#Preview {
    ScrollView {
        ScrollView(.horizontal) {
            HStack {
                SearchAlbumLink_classic(album: SearchedAlbum())
                LoadingSearchAlbum_classic()
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStackWrapped(rows: 2) {
                    LoadingSearchAlbum_classic()
                    LoadingSearchAlbum_classic()
                    LoadingSearchAlbum_classic()
                    LoadingSearchAlbum_classic()
                    LoadingSearchAlbum_classic()
                    LoadingSearchAlbum_classic()
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 10)
            .scrollIndicators(.hidden)
        }
    }
}
