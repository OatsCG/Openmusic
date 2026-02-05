//
//  om_17App.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-05.
//

import SwiftUI
import SwiftData

@main
struct om_17App: App {
    @State var playerManager = PlayerManager()
    @State var playlistImporter = PlaylistImporter()
    @State var downloadManager = DownloadManager.shared
    @State var networkMonitor = NetworkMonitor()
    @State var fontManager = FontManager.shared
    @State var omUser = OMUser()
    @State var sharedDatabase = SharedDatabase.shared
    @Namespace var transitionNamespace
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(playerManager)
                .environment(playlistImporter)
                .environment(downloadManager)
                .environment(networkMonitor)
                .environment(fontManager)
                .environment(omUser)
                .environment(sharedDatabase.database)
                .environmentObject(TransitionWrapper(transitionNamespace))
        }
    }
}
