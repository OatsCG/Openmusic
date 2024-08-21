//
//  SearchedAlbumLink_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

struct SearchAlbumLink_classic: View {
    @Environment(FontManager.self) private var fontManager
    var album: SearchedAlbum
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: album.Artwork, Resolution: .tile, Blur: 80, BlurOpacity: 0.0, cornerRadius: 0.0)
                .scaledToFill()
//                .overlay {
//                    Rectangle()
//                        .fill(LinearGradient(
//                            stops: [
//                                .init(color: .white.opacity(0.1), location: 0.0),
//                                .init(color: .clear, location: 0.1),
//                            ],
//                            startPoint: .top,
//                            endPoint: .bottom
//                        ))
//                }
            VStack(alignment: .leading) {
                Text(album.Title)
                    .foregroundColor(.primary)
                    .customFont(fontManager, .callout)
                Text(stringArtists(artistlist: album.Artists))
                    .foregroundColor(.secondary)
                    .customFont(fontManager, .caption)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 8)
            //Spacer()
        }
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .background {
                AlbumBackground(ArtworkID: album.Artwork, blur: 40, light_opacity: 0.05, dark_opacity: 0.5, spin: false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
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
        SearchAlbumLink_classic(album: SearchedAlbum(default: true))
        SearchAlbumLink_classic(album: SearchedAlbum(default: true))
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
    SearchAlbumLink_classic(album: SearchedAlbum(default: true))
}

#Preview {
    LibraryAlbumLink_classic(tracks: [FetchedTrack(default: true)])
}
