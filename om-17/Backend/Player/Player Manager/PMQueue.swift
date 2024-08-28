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
            self.currentQueueItem = nil
            self.player = PlayerEngine()
            self.player.set_volume(to: self.appVolume)
            self.trackQueue = self.sessionHistory
            self.sessionHistory = []
            self.shouldSuggestPlaylistCreation = false
            self.hasSuggestedPlaylistCreation = false
        }
    }
    
    func clear_all_queue() {
        withAnimation {
            self.currentQueueItem?.clearPlayback()
            self.reset_session_history()
            self.queue_start_over()
        }
    }
    
    func clear_suggestions() {
        self.sessionHistory.removeAll(where: { $0.Track as? ImportedTrack != nil })
    }
    
    func reset_session_history() {
        self.sessionHistory = []
        self.shouldSuggestPlaylistCreation = false
        self.hasSuggestedPlaylistCreation = false
    }
    
    func reset_up_next() {
        self.trackQueue = []
    }
    
    func fresh_play(track: any Track, explicit: Bool? = nil) {
        //self.currentQueueItem?.clearPlayback()
        //self.reset_session_history()
        //self.queue_start_over()
        //self.queue_song(track: track, explicit: explicit)
        self.clear_suggestions()
        self.queue_next(track: track, explicit: explicit)
        //self.play()
        self.player_forward()
    }
    
    func fresh_play_multiple(tracks: [any Track]) {
        self.currentQueueItem?.clearPlayback()
        self.reset_session_history()
        self.queue_start_over()
        self.queue_songs(tracks: tracks)
        self.play()
    }
    
    func fresh_play_multiple(tracks: [PlaylistItem]) {
        self.currentQueueItem?.clearPlayback()
        self.reset_session_history()
        self.queue_start_over()
        self.queue_songs(tracks: tracks.filter({ $0.importData.status == .success }).map{$0.track})
        self.play()
    }
    
    func queue_song(track: any Track, explicit: Bool? = nil) {
        self.trackQueue.append(QueueItem(from: track, explicit: explicit))
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(track.Album.Artwork))
    }
    
    func queue_song(queueItem: QueueItem) {
        self.trackQueue.append(queueItem)
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs(tracks: [any Track], wasSuggested: Bool = false) {
        for track in tracks {
            self.trackQueue.append(QueueItem(from: track))
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.Album.Artwork, count: tracks.count, wasSuggested: wasSuggested))
    }
    
    func queue_songs(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            self.trackQueue.append(QueueItem(from: track))
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_next(track: any Track, explicit: Bool? = nil) {
        self.trackQueue.insert(QueueItem(from: track, explicit: explicit), at: 0)
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(track.Album.Artwork))
    }
    
    func queue_next(queueItem: QueueItem) {
        self.trackQueue.insert(queueItem, at: 0)
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs_next(tracks: [any Track]) {
        for track in tracks.reversed() {
            self.trackQueue.insert(QueueItem(from: track), at: 0)
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_next(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}).reversed() {
            self.trackQueue.insert(QueueItem(from: track), at: 0)
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_randomly(track: any Track, explicit: Bool? = nil) {
        self.trackQueue.insert(QueueItem(from: track, explicit: explicit), at: Int.random(in: 0..<self.trackQueue.count + 1))
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(track.Album.Artwork))
    }
    
    func queue_songs_randomly(tracks: [any Track]) {
        for track in tracks {
            self.trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<self.trackQueue.count + 1))
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_randomly(tracks: [PlaylistItem]) {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            self.trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<self.trackQueue.count + 1))
        }
        self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func remove_from_queue(at: Int) {
        if (at >= 0 && at < self.trackQueue.count) {
            self.trackQueue.remove(at: at)
            self.prime_next_song()
        }
    }
    
    func try_auto_skip_if_necessary() {
        if (self.currentQueueItem?.isDownloaded == false) {
            if self.currentQueueItem?.primeStatus == .failed {
                self.currentQueueItem?.setPrimeStatus(.passed)
                print("AUTOSKIPPED")
                self.player_forward(userInitiated: true)
                return
            }
        }
    }
}
