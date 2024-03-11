//
//  LoadingExplore_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct LoadingExplore_classic: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5).fill(.foreground.opacity(0.04))
                    .frame(width: 130, height: 30)
                    .padding(.leading, 15)
                ScrollView(.horizontal) {
                    HStackWrapped(rows: 2) {
                        ForEach(1...20, id: \.self) { track in
                            LoadingSearchAlbum_classic()
                                .frame(width: SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 10)
                .scrollIndicators(.hidden)
            }
            Divider()
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5).fill(.foreground.opacity(0.04))
                    .frame(width: 130, height: 30)
                    .padding(.leading, 15)
                ScrollView(.horizontal) {
                    HStackWrapped(rows: 2) {
                        ForEach(1...20, id: \.self) { track in
                            LoadingSearchAlbum_classic()
                                .frame(width: SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 10)
                .scrollIndicators(.hidden)
            }
        }
            .opacity(0.8)
    }
}

#Preview {
    ScrollView {
        LoadingExplore_classic()
    }
}
