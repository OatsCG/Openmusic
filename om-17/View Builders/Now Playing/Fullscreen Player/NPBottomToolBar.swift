//
//  BottomToolBar.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI

struct NPBottomToolBar: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(PlaylistImporter.self) var playlistImporter
    @Environment(DownloadManager.self) var downloadManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(FontManager.self) private var fontManager
    @Environment(OMUser.self) var omUser
    @Binding var fullscreen: Bool
    @State var showingQueueSheet = false
    @Binding var carModeEnabled: Bool
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    var body: some View {
        HStack {
            if fullscreen {
                Button {
                    withAnimation {
                        carModeEnabled.toggle()
                    }
                } label: {
                    Image(systemName: "car.fill")
                }
                    .foregroundStyle(carModeEnabled ? .primary : .tertiary)
                    .padding(5)
                    .background(.white.opacity(carModeEnabled ? 0.15 : 0), in: RoundedRectangle(cornerRadius: 5))
                Spacer()
                if carModeEnabled {
                    NPProximity()
                }
                Spacer()
                Button {
                    withAnimation {
                        fullscreen.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                }
                    .foregroundStyle(.tertiary)
            } else {
                Spacer()
                Button(action: {
                    showingQueueSheet.toggle()
                }) {
                    Image(systemName: "play.square.stack")
                }
                Spacer()
                Button(action: {
                    playerManager.cycle_repeat_mode()
                }) {
                    Image(systemName: playerManager.repeatMode == .single ? "repeat.1" : "repeat")
                        .padding(5)
                        .foregroundStyle(playerManager.repeatMode == .off ? .secondary : .primary)
                        .background(.white.opacity(playerManager.repeatMode == .off ? 0 : 0.15), in: RoundedRectangle(cornerRadius: 5))
                }
                Spacer()
                Button {
                    withAnimation {
                        fullscreen.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                }
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
            .customFont(fontManager, .title2)
            .foregroundStyle(.secondary)
            .sheet(isPresented: $showingQueueSheet) {
                QueueSheet(passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet, showingQueueSheet: $showingQueueSheet)
                    .environment(playerManager)
                    .environment(playlistImporter)
                    .environment(downloadManager)
                    .environment(networkMonitor)
                    .environment(fontManager)
                    .environment(omUser)
                    .presentationBackground(.thinMaterial)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.448), .large])
            }
    }
}

//#Preview {
//    NowPlayingSheet()
//}
