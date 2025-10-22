//
//  QSUpNext.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-06.
//

import SwiftUI
import SwiftData

struct QSUpNext: View {
    @AppStorage("DisableQueuingSuggestions") var DisableQueuingSuggestions: Bool = false
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    
    var body: some View {
        if playerManager.trackQueue.isEmpty {
            VStack {
                Spacer()
                if playerManager.fetchSuggestionsModel.isFetching {
                    HStack {
                        Text("Queuing ")
                        ProgressView()
                    }
                        .customFont(fontManager, .title2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Nothing Up Next")
                        .customFont(fontManager, .title2)
                        .foregroundStyle(.secondary)
                    if !DisableQueuingSuggestions && playerManager.currentVibe != nil {
                        Button(action: {
                            playerManager.addSuggestions(noQuestionsAsked: true)
                        }) {
                            AlbumWideButton_component(text: "Queue Suggestions", ArtworkID: "")
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer()
            }
        } else {
            List {
                ForEach(Array(playerManager.trackQueue.enumerated()), id: \.element) { index, track in
                    QSQueueRow(queueItem: track, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet, isQueue: true)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    delete(at: IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.clear)
                        }
                }
                    .onMove(perform: move)
            }
                .background(Color.clear)
                .listStyle(PlainListStyle())
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        var updatedQueue = playerManager.trackQueue
        updatedQueue.move(fromOffsets: source, toOffset: destination)
        playerManager.trackQueue = updatedQueue
        playerManager.prime_next_song()
    }
    
    private func delete(at offsets: IndexSet) {
        var updatedQueue = playerManager.trackQueue
        updatedQueue.remove(atOffsets: offsets)
        playerManager.trackQueue = updatedQueue
        playerManager.prime_next_song()
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
        .task {
            currentTheme = "classic"
//            globalIPAddress = "https://server.openmusic.app"
        }
}
