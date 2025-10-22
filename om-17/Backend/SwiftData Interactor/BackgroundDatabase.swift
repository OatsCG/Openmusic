//
//  BackgroundDatabase.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-06.
//

import Foundation
import SwiftData

@Observable
public final class BackgroundDatabase: Database {
    private actor DatabaseContainer {
        private let factory: @Sendable () -> any Database
        private var wrappedTask: Task<any Database, Never>?
        
        fileprivate init(factory: @escaping @Sendable () -> any Database) {
            self.factory = factory
        }
        
        fileprivate var database: any Database {
            get async {
                if let wrappedTask {
                    return await wrappedTask.value
                }
                let task = Task {
                    factory()
                }
                wrappedTask = task
                return await task.value
            }
        }
    }
    
    private let container: DatabaseContainer
    
    private var database: any Database {
        get async {
            await container.database
        }
    }
    
    internal init(_ factory: @Sendable @escaping () -> any Database) {
        container = .init(factory: factory)
    }
    
    convenience init(modelContainer: ModelContainer) {
        self.init {
          return ModelActorDatabase(modelContainer: modelContainer)
        }
      }
    
    public func delete(where predicate: Predicate<some PersistentModel>?) async throws {
        try await database.delete(where: predicate)
        try save()
      }
    
    public func delete<T>(_ model: T) async where T : PersistentModel {
        await database.delete(model)
        try? save()
    }

    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
        return try await database.fetch(descriptor)
    }

    public func insert(_ model: some PersistentModel) async {
        await database.insert(model)
        try? save()
    }

    public func save() throws {
        Task {
            try await database.save()
        }
    }
    
    func store_track(_ track: any Track) {
        Task {
            if let track = track as? StoredTrack {
                await insert(track)
            } else {
                await insert(StoredTrack(from: track))
            }
            ToastManager.shared.propose(toast: Toast.library(track.Album.Artwork))
        }
    }

    func store_track(_ queueItem: QueueItem) {
        Task {
            await insert(StoredTrack(from: queueItem))
            await ToastManager.shared.propose(toast: Toast.library(queueItem.Track.Album.Artwork))
        }
    }

    func store_tracks(_ tracks: [any Track]) {
        Task {
            for track in tracks {
                if let track = track as? StoredTrack {
                    await insert(track)
                } else {
                    await insert(StoredTrack(from: track))
                }
            }
            ToastManager.shared.propose(toast: Toast.library(tracks.first?.Album.Artwork, count: tracks.count))
        }
    }



    func is_track_stored(TrackID: String) async -> Bool {
        let predicate = #Predicate<StoredTrack> { ptrack in
            ptrack.TrackID == TrackID
        }
        if let ctxp = try? await fetch(FetchDescriptor(predicate: predicate)), !ctxp.isEmpty {
            return true
        }
        return false
    }

    func are_tracks_stored(tracks: [any Track]) async -> Bool {
        if tracks.isEmpty {
            return false
        }
        for track in tracks {
            if await !is_track_stored(TrackID: track.TrackID) {
                return false
            }
        }
        return true
    }

    func fetch_persistent_track(TrackID: String) async -> StoredTrack? {
        let predicate = #Predicate<StoredTrack> { ptrack in
            ptrack.TrackID == TrackID
        }
        if let ctxp = try? await fetch(FetchDescriptor(predicate: predicate)), !ctxp.isEmpty {
            return ctxp.first
        }
        return nil
    }

    func fetch_persistent_playlist(PlaylistID: UUID) async -> StoredPlaylist? {
        let predicate = #Predicate<StoredPlaylist> { playlist in
            playlist.PlaylistID == PlaylistID
        }
        if let ctxp = try? await fetch(FetchDescriptor(predicate: predicate)), !ctxp.isEmpty {
            return ctxp.first
        }
        return nil
    }
}
