//
//  PMQueue.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func clear_all_queue() {
        Task {
            await self.PMActor.clear_all_queue(appVolume: self.appVolume)
            self.updateUI()
        }
    }
    
    func clear_suggestions() {
        Task {
            await self.PMActor.clear_suggestions()
            self.updateUI()
        }
    }
    
    func reset_session_history() {
        Task {
            await self.PMActor.reset_session_history()
            self.updateUI()
        }
    }
    
    func reset_up_next() {
        Task {
            await self.PMActor.reset_up_next()
            self.updateUI()
        }
    }
    
    func fresh_play(track: any Track, explicit: Bool? = nil) {
        Task {
            await self.PMActor.fresh_play(track: track, explicit: explicit)
            self.updateUI()
        }
    }
    
    func fresh_play_multiple(tracks: [any Track]) {
        Task {
            await self.PMActor.fresh_play_multiple(tracks: tracks)
            self.updateUI()
        }
    }
    
    func fresh_play_multiple(tracks: [PlaylistItem]) {
        Task {
            await self.PMActor.fresh_play_multiple(tracks: tracks)
            self.updateUI()
        }
    }
    
    func queue_song(track: any Track, explicit: Bool? = nil) {
        Task {
            await self.PMActor.queue_song(track: track, explicit: explicit)
            self.updateUI()
        }
    }
    
    func queue_song(queueItem: QueueItem) {
        Task {
            await self.PMActor.queue_song(queueItem: queueItem)
            self.updateUI()
        }
    }
    
    func queue_songs(tracks: [any Track], wasSuggested: Bool = false) {
        Task {
            await self.PMActor.queue_songs(tracks: tracks, wasSuggested: wasSuggested)
            self.updateUI()
        }
    }
    
    func queue_songs(tracks: [PlaylistItem]) {
        Task {
            await self.PMActor.queue_songs(tracks: tracks)
            self.updateUI()
        }
    }
    
    func queue_next(track: any Track, explicit: Bool? = nil) {
        Task {
            await self.PMActor.queue_next(track: track, explicit: explicit)
            self.updateUI()
        }
    }
    
    func queue_next(queueItem: QueueItem) {
        Task {
            await self.PMActor.queue_next(queueItem: queueItem)
            self.updateUI()
        }
    }
    
    func queue_songs_next(tracks: [any Track]) {
        Task {
            await self.PMActor.queue_songs_next(tracks: tracks)
            self.updateUI()
        }
    }
    
    func queue_songs_next(tracks: [PlaylistItem]) {
        Task {
            await self.PMActor.queue_songs_next(tracks: tracks)
            self.updateUI()
        }
    }
    
    func queue_randomly(track: any Track, explicit: Bool? = nil) {
        Task {
            await self.PMActor.queue_randomly(track: track, explicit: explicit)
            self.updateUI()
        }
    }
    
    func queue_songs_randomly(tracks: [any Track]) {
        Task {
            await self.PMActor.queue_songs_randomly(tracks: tracks)
            self.updateUI()
        }
    }
    
    func queue_songs_randomly(tracks: [PlaylistItem]) {
        Task {
            await self.PMActor.queue_songs_randomly(tracks: tracks)
            self.updateUI()
        }
    }
    
    func remove_from_queue(at: Int) {
        Task {
            await self.PMActor.remove_from_queue(at: at)
            self.updateUI()
        }
    }
    
    func try_auto_skip_if_necessary() {
        Task {
            await self.PMActor.try_auto_skip_if_necessary()
            self.updateUI()
        }
    }
}
