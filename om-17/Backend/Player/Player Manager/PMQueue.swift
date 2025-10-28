//
//  PMQueue.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func queue_start_over() {
        withAnimation {
            currentQueueItem = nil
            player = PlayerEngine()
            player.set_volume(to: appVolume)
            trackQueue = sessionHistory
            sessionHistory = []
            shouldSuggestPlaylistCreation = false
            hasSuggestedPlaylistCreation = false
        }
    }
    
    func clear_all_queue() {
        withAnimation {
            currentQueueItem?.clearPlayback()
            reset_session_history()
            queue_start_over()
        }
    }
    
    func clear_suggestions() {
        sessionHistory.removeAll(where: { $0.Track as? ImportedTrack != nil })
    }
    
    func reset_session_history() {
        sessionHistory = []
        shouldSuggestPlaylistCreation = false
        hasSuggestedPlaylistCreation = false
    }
    
    func reset_up_next() {
        trackQueue = []
    }
    
    func fresh_play(track: any Track, explicit: Bool? = nil) async {
        //self.currentQueueItem?.clearPlayback()
        //self.reset_session_history()
        //self.queue_start_over()
        //self.queue_song(track: track, explicit: explicit)
        clear_suggestions()
        await queue_next(track: track, explicit: explicit)
        //self.play()
        await player_forward()
    }
    
    func fresh_play_multiple(tracks: [any Track]) async {
        currentQueueItem?.clearPlayback()
        reset_session_history()
        queue_start_over()
        await queue_songs(tracks: tracks)
        await play()
    }
    
    func fresh_play_multiple(tracks: [PlaylistItem]) async {
        currentQueueItem?.clearPlayback()
        reset_session_history()
        queue_start_over()
        await queue_songs(tracks: tracks.filter({ $0.importData.status == .success }).map{$0.track})
        await play()
    }
    
    func queue_song(track: any Track, explicit: Bool? = nil) async {
        trackQueue.append(QueueItem(from: track, explicit: explicit))
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(track.Album.Artwork))
    }
    
    func queue_song(queueItem: QueueItem) async {
        trackQueue.append(queueItem)
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs(tracks: [any Track], wasSuggested: Bool = false) async {
        for track in tracks {
            trackQueue.append(QueueItem(from: track))
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.Album.Artwork, count: tracks.count, wasSuggested: wasSuggested))
    }
    
    func queue_songs(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            trackQueue.append(QueueItem(from: track))
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_next(track: any Track, explicit: Bool? = nil) async {
        trackQueue.insert(QueueItem(from: track, explicit: explicit), at: 0)
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(track.Album.Artwork))
    }
    
    func queue_next(queueItem: QueueItem) async {
        trackQueue.insert(queueItem, at: 0)
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs_next(tracks: [any Track]) async {
        for track in tracks.reversed() {
            trackQueue.insert(QueueItem(from: track), at: 0)
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_next(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}).reversed() {
            trackQueue.insert(QueueItem(from: track), at: 0)
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_randomly(track: any Track, explicit: Bool? = nil) async {
        trackQueue.insert(QueueItem(from: track, explicit: explicit), at: Int.random(in: 0..<trackQueue.count + 1))
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(track.Album.Artwork))
    }
    
    func queue_songs_randomly(tracks: [any Track]) async {
        for track in tracks {
            trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<trackQueue.count + 1))
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_randomly(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<trackQueue.count + 1))
        }
        await prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func remove_from_queue(at: Int) async {
        if at >= 0 && at < trackQueue.count {
            trackQueue.remove(at: at)
            await prime_next_song()
        }
    }
    
    func try_auto_skip_if_necessary() async {
        if currentQueueItem?.isDownloaded == false {
            if currentQueueItem?.primeStatus == .failed {
                currentQueueItem?.update_prime_status(.passed)
                await player_forward(userInitiated: true)
                return
            }
        }
    }
}
