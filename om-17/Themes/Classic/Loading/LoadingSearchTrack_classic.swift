//
//  LoadingSearchTrack_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingSearchTrack_classic: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var gradientStop: CGFloat = 0
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8).fill(.foreground.opacity(0.05))
                .aspectRatio(1, contentMode: .fit)
                .padding([.top, .bottom, .leading], 5)
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5).fill(.foreground.opacity(0.1))
                RoundedRectangle(cornerRadius: 5).fill(.foreground.opacity(0.1))
            }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
            Spacer()
        }
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
            .cornerRadius(11)
            .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                    gradientStop = 2
                }
            }
    }
}

#Preview {
    VStack {
        SearchTrackLink_component(track: FetchedTrack())
        LoadingSearchTrack_classic()
    }
}
