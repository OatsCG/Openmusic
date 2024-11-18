//
//  LibrarySongLink_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI
import SwiftData

struct TrackLink_linen: View {
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 50, BlurOpacity: 0.8, cornerRadius: 8)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(track.Title)
                        .foregroundStyle(.primary)
                        .customFont(fontManager, .callout)
                    if (track.Features.count != 0) {
                        Text(" • " + stringArtists(artistlist: track.Features))
                            .customFont(fontManager, .subheadline)
                    }
                }
                Text(stringArtists(artistlist: track.Album.Artists))
                    .customFont(fontManager, .footnote)
            }
            Spacer()
            Text(secondsToText(seconds: track.Length))
                .customFont(fontManager, .subheadline)
            
            NavigationLink(value: SearchAlbumContentNPM(album: track.Album)) {
                Image(systemName: "chevron.forward.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
            }
//            NavigationLink(destination: SearchAlbumContent(album: track.Album)) {
//                Image(systemName: "chevron.forward.circle.fill")
//                    .font(.title)
//                    .symbolRenderingMode(.hierarchical)
//            }
        }
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding([.vertical, .leading], 5)
            .padding(.trailing, 10)
            .background(.primary.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .contentShape(Rectangle())
            .clipped()
    }
}

#Preview {
    TrackLink_component(currentTheme: "classic", track: FetchedTrack(default: true))
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Previewable @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ContentView()
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
//            globalIPAddress = "server.openmusic.app"
        }
}
