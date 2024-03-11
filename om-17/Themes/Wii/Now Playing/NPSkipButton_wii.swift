//
//  NPSkipButton_wii.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI
import SwiftData

struct NPSkipButton_wii: View {
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
                    Image(systemName: "forward.fill")
                        .symbolEffect(.pulse, isActive: !playerManager.is_next_item_ready())
                        .foregroundStyle(.wiiprimary)
                }
        }
            .font(.system(size: 22))
            .frame(width: 60, height: 60)
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
