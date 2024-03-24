//
//  StoredChecks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI
import SwiftData

func store_track(_ track: any Track, ctx: ModelContext) {
    if let _ = track as? StoredTrack {
        ctx.insert(track as! StoredTrack)
    } else if let _ = track as? FetchedTrack {
        ctx.insert(StoredTrack(from: track as! FetchedTrack))
    }
    ToastManager.shared.propose(toast: Toast.library(track.Album.Artwork))
}

func store_track(_ queueItem: QueueItem, ctx: ModelContext) {
    ctx.insert(StoredTrack(from: queueItem))
    ToastManager.shared.propose(toast: Toast.library(queueItem.Track.Album.Artwork))
    
}

func store_tracks(_ tracks: [any Track], ctx: ModelContext) {
    for track in tracks {
        if let _ = track as? StoredTrack {
            ctx.insert(track as! StoredTrack)
        } else if let _ = track as? FetchedTrack {
            ctx.insert(StoredTrack(from: track as! FetchedTrack))
        }
    }
    ToastManager.shared.propose(toast: Toast.library(tracks.first?.Album.Artwork, count: tracks.count))
}


// THIS IS BAD BAD AND DONE ON THE MAIN THREAD
func is_track_stored(TrackID: String, context: ModelContext) -> Bool {
    let predicate = #Predicate<StoredTrack> { ptrack in
        ptrack.TrackID == TrackID
    }
    if let ctxp = try? context.fetch(FetchDescriptor(predicate: predicate)) {
        if (ctxp.count > 0) {
            return true
        }
    }
    return false
}

func are_tracks_stored(tracks: [any Track], context: ModelContext) -> Bool {
    if tracks.isEmpty {
        return false
    }
    return tracks.allSatisfy { track in
        is_track_stored(TrackID: track.TrackID, context: context)
    }
}

func fetch_persistent_track(TrackID: String, context: ModelContext) -> StoredTrack? {
    let predicate = #Predicate<StoredTrack> { ptrack in
        ptrack.TrackID == TrackID
    }
    if let ctxp = try? context.fetch(FetchDescriptor(predicate: predicate)) {
        if (ctxp.count > 0) {
            return ctxp.first
        }
    }
    return nil
}

func fetch_persistent_playlist(PlaylistID: UUID, context: ModelContext) -> StoredPlaylist? {
    let predicate = #Predicate<StoredPlaylist> { playlist in
        playlist.PlaylistID == PlaylistID
    }
    if let ctxp = try? context.fetch(FetchDescriptor(predicate: predicate)) {
        if (ctxp.count > 0) {
            return ctxp.first
        }
    }
    return nil
}
