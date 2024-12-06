//
//  SearchedAlbumLink_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_linen: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 2.0)
                .shadow(radius: 4, x: 0, y: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 2.0)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .fill(.linearGradient(Gradient(stops: [.init(color: .white.opacity(0.18), location: 0.499), .init(color: .clear, location: 0.50)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            Text(album.Title)
                .foregroundColor(.primary)
                .customFont(fontManager, .callout)
            Text(stringArtists(artistlist: album.Artists))
                .foregroundColor(.secondary)
                .customFont(fontManager, .caption)
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .padding(.all, 2)
            .cornerRadius(10)
    }
}

#Preview {
    @Previewable @State var playerManager = PlayerManager()
    @Previewable @State var playlistImporter = PlaylistImporter()
    @Previewable @State var downloadManager = DownloadManager.shared
    @Previewable @State var networkMonitor = NetworkMonitor()
    @Previewable @State var fontManager = FontManager.shared
    @Previewable @State var omUser = OMUser()
    return HStackWrapped(rows: 2) {
        SearchAlbumLink_linen(album: SearchedAlbum(default: true))
        SearchAlbumLink_linen(album: SearchedAlbum(default: true))
    }
    .padding(10)
    .environment(playerManager)
    .environment(playlistImporter)
    .environment(downloadManager)
    .environment(networkMonitor)
    .environment(fontManager)
    .environment(omUser)
}

#Preview {
    SearchAlbumLink_linen(album: SearchedAlbum(default: true))
}

#Preview {
    LibraryAlbumLink_linen(tracks: [FetchedTrack(default: true)])
}
