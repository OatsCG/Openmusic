//
//  ImportPlaylistSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import SwiftUI

struct ImportPlaylistSheet: View {
    @Environment(BackgroundDatabase.self) private var database  // was \.modelContext
    @Environment(PlaylistImporter.self) var playlistImporter
    @Environment(FontManager.self) private var fontManager
    @Binding var isShowingSheet: Bool
    @State var infoViewModel: PlaylistInfoViewModel = PlaylistInfoViewModel()
    @State var tracksNaiveViewModel: PlaylistTracksNaiveViewModel = PlaylistTracksNaiveViewModel()
    @State var playlistURL: String = ""
    @State var isFetchingTracks: Bool = false
    var body: some View {
        ScrollView {
            Text("Paste your playlist URL here")
                .customFont(fontManager, .title2, bold: true)
            Text("Supports: Apple Music, Spotify")
                .customFont(fontManager, .headline)
            TextField("Playlist URL...", text: $playlistURL)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(.quaternary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .disabled(isFetchingTracks)
                .onAppear {
                    withAnimation {
                        infoViewModel.runSearch(playlistURL: playlistURL)
                    }
                }
                .onChange(of: playlistURL) {
                    withAnimation {
                        infoViewModel.runSearch(playlistURL: playlistURL)
                    }
                }
            // https://music.apple.com/ca/playlist/heard-in-apple-ads/pl.b28c3a5975b04436b42680595f6983ad
            if (infoViewModel.fetchedPlaylistInfo != nil) {
                BetterAsyncImage(url: URL(string: infoViewModel.fetchedPlaylistInfo!.artwork), animated: false)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 50)
                Text(infoViewModel.fetchedPlaylistInfo!.name)
                    .customFont(fontManager, .title, bold: true)
                if infoViewModel.fetchedPlaylistInfo!.description != "" {
                    Text(infoViewModel.fetchedPlaylistInfo!.description)
                        .customFont(fontManager, .headline)
                    Spacer()
                }
            }
            Button(action: {
                if let playlistID = infoViewModel.fetchedPlaylistInfo?.playlistID {
                    isFetchingTracks = true
                    print("FETCH TRACKLIST AND CREATE PLAYLIST")
                    tracksNaiveViewModel.runSearch(playlistID: playlistID, platform: recognizePlaylist(url: playlistURL).platform)
                }
            }) {
                if (recognizePlaylist(url: playlistURL).platform == .unknown) {
                    HStack {
                        Text("Import")
                        Image(systemName: "arrow.down.to.line")
                    }
                        .customFont(fontManager, .title3)
                        .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                        .foregroundStyle(.secondary)
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else if (infoViewModel.fetchedPlaylistInfo == nil) {
                    HStack(spacing: 10) {
                        Text("Searching")
                        ProgressView()
                    }
                        .customFont(fontManager, .title3)
                        .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    HStack {
                        Text("Import")
                        Image(systemName: "arrow.down.to.line")
                    }
                        .customFont(fontManager, .title3)
                        .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                        .background(self.platformColor(platform: recognizePlaylist(url: playlistURL).platform))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
                .buttonStyle(.plain)
                .padding(.top, 10)
                .disabled(isFetchingTracks)
                .onChange(of: tracksNaiveViewModel.fetchedPlaylistInfoTracks) {
                    if let fetchedPlaylistInfoTracks = tracksNaiveViewModel.fetchedPlaylistInfoTracks {
                        let newPlaylist: ImportedPlaylist = ImportedPlaylist(fetchedInfoTracks: fetchedPlaylistInfoTracks, importURL: playlistURL, platform: recognizePlaylist(url: playlistURL).platform)
                        playlistImporter.addPlaylist(playlist: newPlaylist, database: database)
                        isShowingSheet = false
                    }
                }
            if (isFetchingTracks) {
                ProgressView()
            }
        }
            //.padding(.horizontal, 20)
            .safeAreaPadding(.all, 20)
            .multilineTextAlignment(.center)
            .onAppear {
//                if (recognizePlaylist(url: UIPasteboard.general.string ?? "").platform != .unknown) {
//                    self.playlistURL = (UIPasteboard.general.string ?? "")
//                }
            }
    }
    
    func platformColor(platform: Platform) -> Color {
        return switch platform {
        case .apple:
            Color.pink
        case .openmusic:
            Color.purple
        case .spotify:
            Color.green
        case .unknown:
            Color.secondary
        }
    }
}
