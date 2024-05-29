//
//  NPEnjoyingSession.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-26.
//

import SwiftUI
import SwiftData

struct NPEnjoyingSession: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(PlaylistImporter.self) var playlistImporter
    @Environment(FontManager.self) private var fontManager
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            Text("Enjoying this session?")
                .customFont(fontManager, .title3, bold: true)
            Text("Add a playlist of your favourites.")
            Button(action: {
                Task.detached {
                    let playlist = StoredPlaylist(Title: "Listening Session")
                    playlist.Bio = Date().formatted(date: .long, time: .shortened)
                    playlist.Image = nil
                    playlist.importURL = nil
                    
                    let tracksToAdd: [ImportedTrack] = playerManager.sessionHistory.filter({ $0.wasSongEnjoyed == true }).compactMap { $0.Track as? ImportedTrack }
                    playlist.add_tracks(tracks: tracksToAdd.map { FetchedTrack(from: $0) })
                    modelContext.insert(playlist)
                    try? modelContext.save()
                }
                withAnimation {
                    playerManager.hasSuggestedPlaylistCreation = true
                }
            }) {
                AlbumWideButton_component(text: "Make Playlist", subtitle: "", ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork ?? "")
            }
            .buttonStyle(.plain)
            Button(action: {
                withAnimation {
                    playerManager.hasSuggestedPlaylistCreation = true
                }
            }) {
                AlbumWideButton_component(text: "Ignore", ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork ?? "")
            }
            .buttonStyle(.plain)
        }
            .multilineTextAlignment(.center)
            .padding(14)
            .background {
                GlobalBackground_component()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(1), radius: 50)
            //.padding(50)
        
    }
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return NPEnjoyingSession()
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
