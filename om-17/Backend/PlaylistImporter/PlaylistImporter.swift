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
    
    //let config = URLSessionConfiguration.background(withIdentifier: "om17ImportSession")
    //let backgroundSession: URLSession
    init() {
        //self.backgroundSession = URLSession(configuration: self.config, delegate: T##URLSessionDelegate?, delegateQueue: T##OperationQueue?)
        //self.backgroundSession = URLSession(configuration: self.config)
    }
    
    func addPlaylist(playlist: ImportedPlaylist, database: BackgroundDatabase) {
        self.currentContext = database
        self.newPlaylists.append(playlist)
        self.attempt_next_fetch()
    }
    
    func beginTask(playlistImport: PlaylistImport) {
        // start task
        self.publish_status(playlistImport: playlistImport, status: .importing)
        
        Task.detached {
            do {
                let importedTracks = try await fetchPlaylistTracksFetchData(importData: playlistImport.importData)
                await self.publish_imports(playlistImport: playlistImport, imports: importedTracks)
                if (importedTracks.Tracks.count == 0) {
                    await self.publish_status(playlistImport: playlistImport, status: .zeroed)
                } else if (importedTracks.Tracks.first!.isAccurate() == false) { // .score() < 1.5
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
            //try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
            await self.check_playlist_end()
            let nextPlaylist: ImportedPlaylist? = await self.newPlaylists.first(where: { $0.is_importing_successful() == false })
            if let nextPlaylist = nextPlaylist {
                let nextImport = nextPlaylist.items.first(where: { $0.importData.status == .hold })
                if let nextImport = nextImport {
                    //print("attempting next")
                    await self.beginTask(playlistImport: nextImport)
                }
            }
        }
    }
    
    func get_progress(playlistID: UUID) -> Double {
        let playlist: ImportedPlaylist? = self.newPlaylists.first(where: {$0.PlaylistID == playlistID})
        if let playlist = playlist {
            return playlist.import_progress()
        } else {
            return 0
        }
    }
    
    func check_playlist_end() async {
        let successfulPlaylists: [ImportedPlaylist] = self.newPlaylists.filter({$0.is_importing_successful()})
        for playlist in successfulPlaylists {
            let finishedPlaylistIndex: Int? = self.newPlaylists.firstIndex(where: {$0.PlaylistID == playlist.PlaylistID})
            if let finishedPlaylistIndex = finishedPlaylistIndex {
                let storedPlaylist = await StoredPlaylist(from: playlist)
                await self.currentContext?.insert(storedPlaylist)
                try? self.currentContext?.save()
                self.newPlaylists.removeAll(where: {$0.PlaylistID == playlist.PlaylistID})
            }
        }
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
        return(playlist.items.first(where: { $0.id == itemID }))
    }
    
//    func get_index(itemID: UUID) -> Int? {
//        return(self.newImports.firstIndex(where: { $0.id == itemID }))
//    }
    
    func get_playlist(playlistID: UUID) -> ImportedPlaylist? {
        return self.newPlaylists.first(where: { $0.PlaylistID == playlistID })
    }
    
    func get_database() throws -> BackgroundDatabase {
        if (self.currentContext == nil) {
            throw ContextError.noContextAvailable
        } else {
            return self.currentContext!
        }
    }
}

enum ContextError: Error {
    case noContextAvailable
}
