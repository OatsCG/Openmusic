//
//  NPPlayButton_wii.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI
import SwiftData

struct NPPlayButton_wii: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Group {
            Circle().stroke(.wiiborder, lineWidth: 3.0)
                .background {
                    Image(.wiibutton)
                        .resizable()
                        .clipShape(Circle())
                }
                .overlay {
                    Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(.wiiprimary)
                        .contentTransition(.symbolEffect(.replace.offUp))
                }
        }
            .font(.system(size: 35))
            .frame(width: 70, height: 70)
            .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
    }
}


#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return NowPlayingSheet(showingNPSheet: .constant(true), passedNSPath: .constant(NavigationPath()))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "wii"
        }
}
