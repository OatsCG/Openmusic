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
        if player.currentTime.isNaN {
            DispatchQueue.main.async {
                self.elapsedTime = 0
            }
        } else if !player.isSeeking {
            self.elapsedTime = player.currentTime
        }
        if player.has_file() && !player.duration().isNaN {
            let playerDuration = player.duration()
            durationSeconds = playerDuration
            if playerDuration > 0 && playerDuration - elapsedTime - crossfadeSeconds <= 1 { // if close to crossfading
                update_timer(to: 0.01)
            } else {
                update_timer(to: 0.1)
            }
            if elapsedTime > 45 || elapsedNormal > 0.5 {
                // add enjoyed song to recents
                if currentQueueItem?.wasSongEnjoyed == false {
                    withAnimation {
                        if let fetchedTrack = currentQueueItem?.Track as? FetchedTrack {
                            RecentlyPlayedManager.prependRecentTrack(track: fetchedTrack)
                        } else if let importedTrack = currentQueueItem?.Track as? ImportedTrack {
                            RecentlyPlayedManager.prependRecentTrack(track: FetchedTrack(from: importedTrack))
                        }
                    }
                }
                currentQueueItem?.userEnjoyedSong()
                trySuggestingPlaylistCreation()
            }
        } else {
            durationSeconds = 0.9
        }
        DispatchQueue.main.async {
            withAnimation {
                self.elapsedNormal = self.elapsedTime / self.durationSeconds
            }
        }
    }
    
    func change_volume(to: Float) {
        appVolume = to
        player.set_volume(to: appVolume)
    }
    
    func set_currentlyPlaying(queueItem: QueueItem) {
        if let currentQueueItem {
            if currentQueueItem.queueID == queueItem.queueID {
                if currentQueueItem.queueItemPlayer != nil {
                    //if current avplayer doesnt equal queueitem avplayer
                    if let queueItemPlayer = queueItem.queueItemPlayer, !player.isEqual(to: queueItemPlayer) {
                        // NEW SONG SET
                        player.pause()
                        player = queueItemPlayer
                        player.set_volume(to: appVolume)
                        if is_playing() {
                            player.playImmediately()
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
        
        setAudioSession()
        Task {
            addSuggestions()
        }
    }
    
    func setAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session route sharing policy: \(error)")
        }
    }
}
