//
//  LoadingSearchResults_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingSearchResults_spotty: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5).fill(.foreground.opacity(0.04))
                    .frame(width: 130, height: 30)
                    .padding(.leading, 15)
                ScrollView(.horizontal) {
                    HStackWrapped(rows: 3) {
                        ForEach(1...20, id: \.self) { track in
                            LoadingSearchTrack_classic()
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
        LoadingSearchResults_spotty()
            .opacity(0.8)
    }
}
