//
//  ContentView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-05.
//


import SwiftUI
import SwiftData
//142.189.12.151

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(FontManager.self) var fontManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @AppStorage("onboard_1.2.2") var onboard: Bool = true
    @State var selections: (Int, Int) = (-1, 0) // (previous, current)
    @State var exploreNSPath = NavigationPath()
    @State var searchNSPath = NavigationPath()
    @State var libraryNSPath = NavigationPath()
    @State var tabbarHeight: CGFloat = 83
    var selectionBinding: Binding<Int> { Binding(
        get: {
            self.selections.1
        },
        set: {
            self.selections = (self.selections.1, $0)
            if (self.selections.0 == self.selections.1) {
                print("Pop to root view for first tab!!")
                if (self.selections.1 == 0) {
                    exploreNSPath = NavigationPath()
                } else if (self.selections.1 == 1) {
                    searchNSPath = NavigationPath()
                } else if (self.selections.1 == 2) {
                    libraryNSPath = NavigationPath()
                }
            }
        }
    )}
    
    var body: some View {
//        MainNavigationTabbed(exploreNSPath: $exploreNSPath, searchNSPath: $searchNSPath, libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight, selectionBinding: selectionBinding)
//            .sheet(isPresented: $onboard) {
//                onboard = false
//            } content: {
//                OnboardSheet(onboard: $onboard)
//                    .tint(GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme))
//            }

        Group {
            if (horizontalSizeClass == .regular && verticalSizeClass == .regular) {
                MainNavigationSidebar(exploreNSPath: $exploreNSPath, searchNSPath: $searchNSPath, libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight, selectionBinding: selectionBinding)
            } else {
                MainNavigationSidebar(exploreNSPath: $exploreNSPath, searchNSPath: $searchNSPath, libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight, selectionBinding: selectionBinding)
            }
        }
        .sheet(isPresented: $onboard) {
            onboard = false
        } content: {
            OnboardSheet(onboard: $onboard)
                .tint(GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme))
        }
    }
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
        .environment(FontManager())
        .environment(OMUser())
        .task {
            currentTheme = "classic"
//            globalIPAddress = "server.openmusic.app"
        }
}
