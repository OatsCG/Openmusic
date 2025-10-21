//
//  PlaylistEditMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-31.
//

import SwiftUI
import SwiftData
import PhotosUI

struct PlaylistEditMenu: View {
    @Environment(BackgroundDatabase.self) private var database
    @Environment(PlaylistImporter.self) var playlistImporter
    var playlist: StoredPlaylist
    @State var playlistTitle: String
    @State var playlistBio: String
    @State var avatarItem: PhotosPickerItem?
    @State var deleteImageAlert: Bool = false
    @State var clearPlaylistAlert: Bool = false
    @State var deletePlaylistAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Playlist Title...", text: $playlistTitle)
                    .onChange(of: playlistTitle) {
                        playlist.Title = playlistTitle
                    }
            }
            Section(header: Text("Description")) {
                TextField("Playlist Description...", text: $playlistBio)
                    .onChange(of: playlistBio) {
                        playlist.Bio = playlistBio
                    }
            }
            Section {
                HStack {
                    PhotosPicker("Choose Photo...", selection: $avatarItem, matching: .images)
                        .photosPickerStyle(.presentation)
                    Spacer()
                    PlaylistArtwork(playlist: playlist, animate: true)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                    .onChange(of: avatarItem) {
                        Task {
                            if let loaded = try? await avatarItem?.loadTransferable(type: Data.self) {
                                if let contentType = avatarItem?.supportedContentTypes.first {
                                    let url = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
                                    do {
                                        try loaded.write(to: url)
                                        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Playlist-\(playlist.PlaylistID.uuidString).jpg")
                                        playlist.Image = destinationURL?.absoluteString
                                        try loaded.write(to: destinationURL ?? url, options: .atomic)
                                        print(url.absoluteString)
                                    } catch {
                                        print("Failed")
                                    }
                                }
                            } else {
                                print("Failed")
                            }
                        }
                    }
                if playlist.Image != nil {
                    Button("Remove Image", role: .destructive) {
                        deleteImageAlert.toggle()
                    }
                        .alert("Remove playlist image?", isPresented: $deleteImageAlert) {
                            Button("Delete", role: .destructive) {
                                playlist.Image = nil
                            }
                        }
                } else {
                    Button("Shuffle Aura") {
                        playlist.PlaylistID = UUID()
                    }
                }
            } header: {
                Text("ARTWORK")
            }
            
            if (getItemsMatching(items: playlist.items, status: [.success]).count != playlist.items.count) {
                Section(header: Text("Importing")) {
                    if (getItemsMatching(items: playlist.items, status: [.uncertain]).count > 0) {
                        NavigationLink(value: PlaylistReviewTracksNPM(playlist: playlist)) {
                            Image(systemName: "exclamationmark.circle")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .orange)
                            Text("Review \(getItemsMatching(items: playlist.items, status: [.uncertain]).count) Tracks")
                        }
                    }
                }
            }
            Section {
                Button("Clear Playlist...", role: .destructive) {
                    clearPlaylistAlert.toggle()
                }
                    .alert("Are you sure you want to clear playlist? This will remove all songs from this playlist.", isPresented: $clearPlaylistAlert) {
                        Button("Clear", role: .destructive) {
                            playlist.items = []
                        }
                    }
                Button("Delete Playlist...", role: .destructive) {
                    deletePlaylistAlert.toggle()
                }
                    .alert("Are you sure you want to delete playlist? This will remove this playlist from your library. This cannot be undone.", isPresented: $deletePlaylistAlert) {
                        Button("Delete", role: .destructive) {
                            Task {
                                await database.delete(playlist)
                            }
                        }
                    }
            } header: {
                Text("DELETE PLAYLIST")
            } footer: {
                Text("**Creation Date:** \(playlist.dateCreated)\n**Origin Platform:** \(playlist.items.first?.importData.from.platform.rawValue.capitalized ?? "None")\n**Origin URL:** \(playlist.importURL ?? "None")")
            }
        }
            .safeAreaPadding(.bottom, 80)
    }
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

struct movetest: View {
    var playlist: StoredPlaylist
    @State var selectedItems : Set<PlaylistItem> = Set<PlaylistItem>()
    
    var body: some View {
        NavigationStack {
            if playlist.items.isEmpty {
                ContentUnavailableView {
                    Label("No Songs in Playlist", systemImage: "play.square.stack")
                } description: {
                    Text("Adding songs from here will come in the future.")
                }
            } else {
                List(selection: $selectedItems) {
                    ForEach(playlist.items, id:\.self) { item in
                        Text(item.track.Title)
                            .tag(item)
                    }
                    .onMove(perform: move)
                }
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        playlist.performMove(source: source, destination: destination)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    let playlist = StoredPlaylist(Title: "Test!")
    playlist.add_items(items: [PlaylistItem(track: FetchedTrack(default: true), playlistID: UUID(), index: 0), PlaylistItem(track: FetchedTrack(default: true), playlistID: UUID(), index: 1), PlaylistItem(track: FetchedTrack(default: true), playlistID: UUID(), index: 2)])
    
    return NavigationStack {
        PlaylistEditMenu(playlist: playlist, playlistTitle: playlist.Title, playlistBio: playlist.Bio)
    }
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
}
