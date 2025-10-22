//
//  PlaylistImporter.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-06.
//

import SwiftUI
import SwiftData

@MainActor
@Observable class PlaylistImporter {
    var newPlaylists: [ImportedPlaylist] = []
    var currentContext: BackgroundDatabase? = nil
    var isCheckingEnd: Bool = false
    
    init() { }
    
    func addPlaylist(playlist: ImportedPlaylist, database: BackgroundDatabase) {
        currentContext = database
        withAnimation {
            newPlaylists.append(playlist)
        }
        attempt_next_fetch()
    }
    
    func beginTask(playlistImport: PlaylistImport) {
        // start task
        publish_status(playlistImport: playlistImport, status: .importing)
        
        Task.detached {
            do {
                let importedTracks = try await fetchPlaylistTracksFetchData(importData: playlistImport.importData)
                await self.publish_imports(playlistImport: playlistImport, imports: importedTracks)
                if importedTracks.Tracks.isEmpty {
                    await self.publish_status(playlistImport: playlistImport, status: .zeroed)
                } else if importedTracks.Tracks.first?.isAccurate() == false {
                    await self.publish_status(playlistImport: playlistImport, status: .uncertain)
                } else {
                    await self.publish_status(playlistImport: playlistImport, status: .success)
                    await self.publish_successful_track(playlistImport: playlistImport, track: importedTracks.Tracks.first!)
                }
                await self.attempt_next_fetch()
            } catch {
                await self.publish_status(playlistImport: playlistImport, status: .hold)
                await self.attempt_next_fetch()
            }
        }
    }
    
    func attempt_next_fetch() {
        Task.detached {
            await self.check_playlist_end()
            let nextPlaylist: ImportedPlaylist? = await self.newPlaylists.first(where: { !$0.is_importing_successful() })
            if let nextPlaylist {
                let nextImport = nextPlaylist.items.first(where: { $0.importData.status == .hold })
                if let nextImport {
                    await self.beginTask(playlistImport: nextImport)
                }
            }
        }
    }
    
    func get_progress(playlistID: UUID) -> Double {
        if let playlist = newPlaylists.first(where: {$0.PlaylistID == playlistID}) {
            return playlist.import_progress()
        } else {
            return 0
        }
    }
    
    func check_playlist_end() async {
        guard !isCheckingEnd else { return }
        isCheckingEnd = true
        let successfulPlaylists: [ImportedPlaylist] = newPlaylists.filter({$0.is_importing_successful()})
        for playlist in successfulPlaylists {
            if newPlaylists.firstIndex(where: {$0.PlaylistID == playlist.PlaylistID}) != nil {
                let storedPlaylist = await StoredPlaylist(from: playlist)
                await currentContext?.insert(storedPlaylist)
                try? currentContext?.save()
                withAnimation {
                    newPlaylists.removeAll(where: {$0.PlaylistID == playlist.PlaylistID})
                }
            }
        }
        isCheckingEnd = false
    }
    
    func publish_status(playlistImport: PlaylistImport, status: ImportStatus) {
        playlistImport.set_status(status: status)
        Task.detached {
            await self.check_playlist_end()
        }
    }
    
    func publish_imports(playlistImport: PlaylistImport, imports: ImportedTracks) {
        playlistImport.set_imports(tracks: imports)
    }
    
    func publish_successful_track(playlistImport: PlaylistImport, track: ImportedTrack) {
        playlistImport.set_successful_track(track: track)
    }
    
    func fetch_playlist_item(playlist: StoredPlaylist, itemID: UUID) -> PlaylistItem? {
        playlist.items.first(where: { $0.id == itemID })
    }
    
    func get_playlist(playlistID: UUID) -> ImportedPlaylist? {
        newPlaylists.first(where: { $0.PlaylistID == playlistID })
    }
    
    func get_database() throws -> BackgroundDatabase {
        if let currentContext {
            return currentContext
        } else {
            throw ContextError.noContextAvailable
        }
    }
}

enum ContextError: Error {
    case noContextAvailable
}
