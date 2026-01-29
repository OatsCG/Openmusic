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
    
    func fresh_play(track: any Track, explicit: Bool? = nil) {
        //self.currentQueueItem?.clearPlayback()
        //self.reset_session_history()
        //self.queue_start_over()
        //self.queue_song(track: track, explicit: explicit)
        clear_suggestions()
        queue_next(track: track, explicit: explicit)
        //self.play()
        player_forward()
    }
    
    func fresh_play_multiple(tracks: [any Track]) {
        currentQueueItem?.clearPlayback()
        reset_session_history()
        queue_start_over()
        queue_songs(tracks: tracks)
        play()
    }
    
    func fresh_play_multiple(tracks: [PlaylistItem]) {
        currentQueueItem?.clearPlayback()
        reset_session_history()
        queue_start_over()
        queue_songs(tracks: tracks.filter({ $0.importData.status == .success }).map{$0.track})
        play()
    }
    
    func queue_song(track: any Track, explicit: Bool? = nil) {
        trackQueue.append(QueueItem(from: track, explicit: explicit))
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(track.Album.Artwork))
    }
    
    func queue_song(queueItem: QueueItem) {
        trackQueue.append(queueItem)
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs(tracks: [any Track], wasSuggested: Bool = false) {
        for track in tracks {
            trackQueue.append(QueueItem(from: track))
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.Album.Artwork, count: tracks.count, wasSuggested: wasSuggested))
    }
    
    func queue_songs(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            trackQueue.append(QueueItem(from: track))
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_next(track: any Track, explicit: Bool? = nil) {
        trackQueue.insert(QueueItem(from: track, explicit: explicit), at: 0)
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(track.Album.Artwork))
    }
    
    func queue_next(queueItem: QueueItem) {
        trackQueue.insert(queueItem, at: 0)
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs_next(tracks: [any Track]) {
        for track in tracks.reversed() {
            trackQueue.insert(QueueItem(from: track), at: 0)
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_next(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}).reversed() {
            trackQueue.insert(QueueItem(from: track), at: 0)
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_randomly(track: any Track, explicit: Bool? = nil) {
        trackQueue.insert(QueueItem(from: track, explicit: explicit), at: Int.random(in: 0..<trackQueue.count + 1))
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(track.Album.Artwork))
    }
    
    func queue_songs_randomly(tracks: [any Track]) {
        for track in tracks {
            trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<trackQueue.count + 1))
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_randomly(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<trackQueue.count + 1))
        }
        prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func remove_from_queue(at: Int) {
        if at >= 0 && at < trackQueue.count {
            trackQueue.remove(at: at)
            prime_next_song()
        }
    }
    
    func try_auto_skip_if_necessary() {
        if currentQueueItem?.isDownloaded == false {
            if currentQueueItem?.primeStatus == .failed {
                currentQueueItem?.update_prime_status(.passed)
                player_forward(userInitiated: true)
                return
            }
        }
    }
    
    func refresh_if_necessary() {
        // if ready but duration is nil, refresh
        if currentQueueItem?.audio_AVPlayer?.isReady == true && currentQueueItem?.isReady() == false {
            self.currentQueueItem?.prime_object_fresh(playerManager: self, continueCurrent: false, seek: false)
        }
    }
}
