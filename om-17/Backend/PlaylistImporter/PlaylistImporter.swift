//
//  PlaylistImporter.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-06.
//

import SwiftUI
import SwiftData


@Observable final class PlaylistImporter: Sendable {
    var newPlaylists: [ImportedPlaylist] = []
    var currentContext: ModelContext? = nil
    
    //let config = URLSessionConfiguration.background(withIdentifier: "om17ImportSession")
    //let backgroundSession: URLSession
    init() {
        //self.backgroundSession = URLSession(configuration: self.config, delegate: T##URLSessionDelegate?, delegateQueue: T##OperationQueue?)
        //self.backgroundSession = URLSession(configuration: self.config)
    }
    
    func addPlaylist(playlist: ImportedPlaylist, context: ModelContext) {
        self.currentContext = context
        self.newPlaylists.append(playlist)
        self.attempt_next_fetch()
    }
    
    func beginTask(playlistImport: PlaylistImport) {
        // start task
        self.publish_status(playlistImport: playlistImport, status: .importing)
        
        fetchPlaylistTracksFetchData(importData: playlistImport.importData) { (result) in
            switch result {
            case .success(let importedTracks):
                self.publish_imports(playlistImport: playlistImport, imports: importedTracks)
                if (importedTracks.Tracks.count == 0) {
                    self.publish_status(playlistImport: playlistImport, status: .zeroed)
                } else if (importedTracks.Tracks.first!.isAccurate() == false) { // .score() < 1.5
                    self.publish_status(playlistImport: playlistImport, status: .uncertain)
                } else {
                    self.publish_status(playlistImport: playlistImport, status: .success)
                    self.publish_successful_track(playlistImport: playlistImport, track: importedTracks.Tracks.first!)
                }
                self.attempt_next_fetch()
            case .failure(let error):
                print(error)
                self.publish_status(playlistImport: playlistImport, status: .hold)
                self.attempt_next_fetch()
            }
        }
    }
    
    func attempt_next_fetch() {
        Task.detached {
            //try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
            self.check_playlist_end()
            let nextPlaylist: ImportedPlaylist? = self.newPlaylists.first(where: { $0.is_importing_successful() == false })
            if let nextPlaylist = nextPlaylist {
                let nextImport = nextPlaylist.items.first(where: { $0.importData.status == .hold })
                if let nextImport = nextImport {
                    //print("attempting next")
                    self.beginTask(playlistImport: nextImport)
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
    
    func check_playlist_end() {
        let successfulPlaylists: [ImportedPlaylist] = self.newPlaylists.filter({$0.is_importing_successful()})
        for playlist in successfulPlaylists {
            DispatchQueue.main.async {
                let finishedPlaylistIndex: Int? = self.newPlaylists.firstIndex(where: {$0.PlaylistID == playlist.PlaylistID})
                if let finishedPlaylistIndex = finishedPlaylistIndex {
                    let storedPlaylist = StoredPlaylist(from: playlist)
                    self.currentContext?.insert(storedPlaylist)
                    try? self.currentContext?.save()
                    self.newPlaylists.remove(at: finishedPlaylistIndex)
                }
            }
        }
    }
    
    func publish_status(playlistImport: PlaylistImport, status: ImportStatus) {
        DispatchQueue.main.async {
            playlistImport.set_status(status: status)
            Task.detached {
                self.check_playlist_end()
            }
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
    
    func get_context() throws -> ModelContext {
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
