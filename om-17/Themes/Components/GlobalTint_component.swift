//
//  GlobalTint_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI
import SwiftData

func GlobalTint_component(currentTheme: String, colorScheme: ColorScheme) -> Color {
    switch currentTheme {
    case "classic":
        if (colorScheme == .dark) {
            return Color(hue: 0.7, saturation: 0.45, brightness: 1)
        } else {
            return Color(hue: 0.7, saturation: 0.55, brightness: 1)
        }
    case "honeycrisp":
        return .pink
    case "wii":
        return .cyan
    case "spotty":
        return .white
    case "faero":
        return .blue
    case "feco":
        return .green
    case "linen":
        return .blue
    default:
        return .primary
    }
}

#Preview {
    Text("Tint Colour (WITH A 'U')")
        .foregroundStyle(GlobalTint_component(currentTheme: "spotty", colorScheme: .dark))
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
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
        }
}
