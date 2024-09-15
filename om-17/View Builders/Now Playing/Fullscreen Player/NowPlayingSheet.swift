//
//  NowPlayingSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI
import SwiftData
import MarqueeText

struct NowPlayingSheet: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(FontManager.self) private var fontManager
    @Binding var showingNPSheet: Bool
    @State var fullscreen: Bool = false
    @State var carModeEnabled: Bool = false
    @Binding var passedNSPath: NavigationPath
    @State var currentAlbum: SearchedAlbum? = nil
    @State var attentionOpacity: Double = 1
    @State private var timer: Timer? = nil
    
    var namespace: Namespace.ID? = nil
    func onTap() {
        print("TAP RECOGNISED")
        timer?.invalidate()
        withAnimation {
            self.attentionOpacity = 1
        }
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 4)) {
                    self.attentionOpacity = 0
                }
            }
        }
    }
    
    var body: some View {
        NowPlayingSheetContent(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath, currentAlbum: $currentAlbum, attentionOpacity: $attentionOpacity)
            .contentShape(Rectangle())
            .simultaneousGesture(TapGesture().onEnded({
                self.onTap()
            }))
    }
}

struct NowPlayingSheetContent: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(FontManager.self) private var fontManager
    @Binding var showingNPSheet: Bool
    @Binding var fullscreen: Bool
    @Binding var carModeEnabled: Bool
    @Binding var passedNSPath: NavigationPath
    @Binding var currentAlbum: SearchedAlbum?
    @Binding var attentionOpacity: Double
    
    var namespace: Namespace.ID? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                showingNPSheet = false
            }) {
                Image(systemName: "chevron.compact.down")
                    .customFont(fontManager, .title)
                    .foregroundStyle(.tertiary)
                    .opacity(0.7)
                    .opacity(fullscreen ? attentionOpacity : 1)
                    .disabled(fullscreen ? (attentionOpacity == 1 ? false : true) : false)
            }
            if fullscreen {
                if carModeEnabled {
                    NPProximityWarning()
                }
            }
            VStack {
                if (verticalSizeClass == .compact || horizontalSizeClass == .regular) {
                    // landscape
                    HStack(spacing: 20) {
                        NPHeaderSegment(fullscreen: $fullscreen, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                        VStack {
                            Spacer()
                            NPInfoSegment(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath)
                            Spacer()
                            NPBottomToolBar(fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                                .opacity(fullscreen ? attentionOpacity : 1)
                        }
                    }
                    .persistentSystemOverlays(.hidden)
                    .statusBarHidden(fullscreen ? (attentionOpacity == 1 ? false : true) : false)
                } else {
                    // portrait
                    VStack {
                        Spacer()
                        NPHeaderSegment(fullscreen: $fullscreen, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                        NPInfoSegment(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath)
                        Spacer()
                        NPBottomToolBar(fullscreen: $fullscreen, carModeEnabled: $carModeEnabled, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                            .opacity(fullscreen ? attentionOpacity : 1)
                            .disabled(fullscreen ? (attentionOpacity == 1 ? false : true) : false)
                    }
                    .persistentSystemOverlays(fullscreen ? (attentionOpacity == 1 ? .automatic : .hidden) : .automatic)
                    .statusBarHidden(fullscreen ? (attentionOpacity == 1 ? false : true) : false)
                }
            }
        }
            .safeAreaPadding(20)
            .tint(.primary)
            .background {
                NPBackground_component(album: currentAlbum, fullscreen: $fullscreen)
            }
            .onAppear {
                Task { [self] in
                    let album: SearchedAlbum? = self.playerManager.currentQueueItem?.Track.Album
                    DispatchQueue.main.async { [self, album] in
                        self.currentAlbum = album
                    }
                }
            }
            .onChange(of: playerManager.currentQueueItem) {
                Task { [self] in
                    let album: SearchedAlbum? = self.playerManager.currentQueueItem?.Track.Album
                    DispatchQueue.main.async { [self, album] in
                        self.currentAlbum = album
                    }
                }
            }
    }
}


//#Preview {
//    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
//    @Previewable @AppStorage("globalIPAddress") var globalIPAddress: String = ""
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
//
//    let playlist = StoredPlaylist(Title: "Test!")
//    container.mainContext.insert(playlist)
//    
//    return ContentView()
//        .modelContainer(container)
//        .environment(PlayerManager())
//        .environment(PlaylistImporter())
//        .environment(DownloadManager())
//        .environment(NetworkMonitor())
//        .environment(FontManager())
//        .environment(OMUser())
//        .task {
//            currentTheme = "classic"
////            globalIPAddress = "server.openmusic.app"
//        }
//}
