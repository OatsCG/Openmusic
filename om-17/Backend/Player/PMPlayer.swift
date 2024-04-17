//
//  PMPlayer.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func update_elapsed_time() {
        if (self.player.currentTime.isNaN) {
            self.elapsedTime = 0
        } else if (self.player.isSeeking == false) {
            let playerTime: Double = self.player.currentTime
            self.elapsedTime = playerTime
        }
        if (self.player.has_file() && self.player.duration().isNaN == false) {
            let playerDuration: Double = self.player.duration()
            self.durationSeconds = playerDuration
            if (playerDuration > 0 && playerDuration - self.elapsedTime - self.crossfadeSeconds <= 1) { // if close to crossfading
                self.update_timer(to: 0.01)
            } else {
                self.update_timer(to: 0.05)
            }
            if (self.elapsedTime > 45 || self.elapsedNormal > 0.5) {
                // add enjoyed song to recents
                if (self.currentQueueItem?.wasSongEnjoyed == false) {
                    withAnimation {
                        if let fetchedTrack = self.currentQueueItem?.Track as? FetchedTrack {
                            RecentlyPlayedManager.prependRecentTrack(track: fetchedTrack)
                        } else if let importedTrack = self.currentQueueItem?.Track as? ImportedTrack {
                            RecentlyPlayedManager.prependRecentTrack(track: FetchedTrack(from: importedTrack))
                        }
                    }
                }
                self.currentQueueItem?.userEnjoyedSong()
                self.trySuggestingPlaylistCreation()
            }
        } else {
            self.durationSeconds = 0.9
        }
        Task {
            withAnimation {
                self.elapsedNormal = self.elapsedTime / self.durationSeconds
            }
        }
    }
    
    func change_volume(to: Float) {
        self.appVolume = to
        self.player.set_volume(to: self.appVolume)
    }
    
    func set_currentlyPlaying(queueItem: QueueItem) {
        if (self.currentQueueItem != nil) {
            if (self.currentQueueItem!.queueID == queueItem.queueID) {
                if (self.currentQueueItem!.queueItemPlayer != nil) {
                    //if current avplayer doesnt equal queueitem avplayer
                    if (queueItem.queueItemPlayer != nil && !self.player.isEqual(to: queueItem.queueItemPlayer)) {
                        if queueItem.queueItemPlayer != nil {
                            // NEW SONG SET
                            self.player.pause()
                            self.player = queueItem.queueItemPlayer!
                            self.player.set_volume(to: self.appVolume)
                            if (self.is_playing()) {
                                self.player.playImmediately()
                            }
                        }
                        setupNowPlaying()
                        defineInterruptionObserver()
                    }
                }
            } else {
                queueItem.audio_AVPlayer?.pause()
            }
        } else {
            queueItem.audio_AVPlayer?.pause()
        }
        self.setAudioSession()
        self.addSuggestions()
    }
    
    func setAudioSession() {
        do {
            try self.audioSession.setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try self.audioSession.setActive(true)
        } catch {
            print("Failed to set audio session route sharing policy: \(error)")
        }
    }
}
