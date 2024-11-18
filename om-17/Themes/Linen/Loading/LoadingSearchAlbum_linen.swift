//
//  LoadingSearchAlbum_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingSearchAlbum_linen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var gradientStop: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            RoundedRectangle(cornerRadius: 0).fill(.foreground.opacity(0.03))
                .aspectRatio(1, contentMode: .fill)
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 2).fill(.foreground.opacity(0.05))
                    .frame(width: 120)
                RoundedRectangle(cornerRadius: 2).fill(.foreground.opacity(0.03))
                    .frame(width: 90)
            }
                .padding(.all, 4)
        }
            .background(.foreground.opacity(0.05))
            .overlay {
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            Gradient.Stop(
                                color: .clear,
                                location: 0
                            ),
                            Gradient.Stop(
                                color: .primary.opacity(0.03),
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
                gradientStop = 0
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                    gradientStop = 2
                }
            }
    }
}

#Preview {
    @Previewable @State var playerManager = PlayerManager()
    @Previewable @State var playlistImporter = PlaylistImporter()
    @Previewable @State var downloadManager = DownloadManager.shared
    @Previewable @State var networkMonitor = NetworkMonitor()
    @Previewable @State var fontManager = FontManager.shared
    @Previewable @State var omUser = OMUser()
    ScrollView {
        ScrollView(.horizontal) {
            HStackWrapped(rows: 2) {
                ForEach(1...10, id: \.self) { track in
                    LoadingSearchAlbum_linen()
                }
            }
        }
        ScrollView(.horizontal) {
            HStackWrapped(rows: 2) {
                ForEach(1...10, id: \.self) { track in
                    SearchAlbumLink_linen(album: SearchedAlbum())
                }
            }
        }
    }
    .padding(10)
    .environment(playerManager)
    .environment(playlistImporter)
    .environment(downloadManager)
    .environment(networkMonitor)
    .environment(fontManager)
    .environment(omUser)
    .background {
        GlobalBackground_linen()
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStackWrapped(rows: 2) {
                    LoadingSearchAlbum_linen()
                    LoadingSearchAlbum_linen()
                    LoadingSearchAlbum_linen()
                    LoadingSearchAlbum_linen()
                    LoadingSearchAlbum_linen()
                    LoadingSearchAlbum_linen()
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 10)
            .scrollIndicators(.hidden)
        }
    }
}
