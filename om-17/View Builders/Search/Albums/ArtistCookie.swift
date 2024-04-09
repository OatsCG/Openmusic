//
//  ArtistCookie.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct ArtistCookie: View {
    @Environment(FontManager.self) private var fontManager
    var artist: SearchedArtist
    var body: some View {
        HStack(spacing: 3) {
            ArtistCookieImageDisplay(imgURL: BuildArtistCookieImageURL(imgID: artist.Profile_Photo, resolution: .cookie), Blur: 0, BlurOpacity: 0)
            //ArtistCookieImageDisplay(imgURL: BuildArtistCookieImageURL(imgID: artist.Profile_Photo, resolution: .cookie), Blur: 20, BlurOpacity: 1)
                //.brightness(2)
                //.frame(width: 40, height: 40)
            Text(artist.Name)
                .foregroundColor(.primary)
                .customFont(fontManager, .subheadline, bold: true)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
            .frame(maxWidth: 200, maxHeight: 40)
            .contextMenu {
                ArtistMenu(artist: artist)
                    .environment(fontManager)
            }
            //.border(.red)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return SearchAlbumContent(album: SearchedAlbum(default: true))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}

#Preview {
    HStack {
        ScrollView(.horizontal) {
            HStack {
                Spacer()
                HStack(spacing: 10) {
                    ForEach([SearchedArtist(default: true)], id: \.ArtistID) { artist in
                        ArtistCookie(artist: artist)
                        //.border(.red)
                    }
                }
                .scrollTargetLayout()
                .border(.blue)
                Spacer()
            }
        }
        .border(.red)
        //.scrollIndicators(.hidden)
        .padding(.leading, 20)
        .scrollTargetBehavior(.viewAligned)
    }
}
