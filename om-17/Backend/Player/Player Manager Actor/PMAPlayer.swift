//
//  PMAPlayer.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI
import AVFoundation

extension PlayerManagerActor {
    func setVolume(to: Float) {
        self.player.set_volume(to: to)
    }
    
    func switchCurrentlyPlaying(queueItem: QueueItem) async {
        let inputQueueItemPlayer: (any PlayerEngineProtocol)? = await queueItem.getQueueItemPlayer()
        if let currentQueueItem = self.currentQueueItem {
            if (currentQueueItem.queueID == queueItem.queueID) {
                let currentQueueItemPlayer: (any PlayerEngineProtocol)? = await currentQueueItem.getQueueItemPlayer()
                if let currentQueueItemPlayer = currentQueueItemPlayer {
                    //if current avplayer doesnt equal queueitem avplayer
                    if (inputQueueItemPlayer != nil && !self.player.isEqual(to: inputQueueItemPlayer)) {
                        if let player = inputQueueItemPlayer {
                            // NEW SONG SET
                            self.player.pause()
                            self.player = player
                            self.player.set_volume(to: self.appVolume)
                            
                            if (self.isPlaying) {
                                self.player.playImmediately()
                            }
                        }
                        await self.setupNowPlaying()
                    }
                }
            } else {
                await queueItem.pauseAVPlayer()
            }
        } else {
            await queueItem.pauseAVPlayer()
        }
        self.setAudioSession()
    }
    
    func update_elapsed_time() async {
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
                self.update_timer(to: 0.1)
            }
            if (self.elapsedTime > 45 || self.elapsedNormal > 0.5) {
                // add enjoyed song to recents
                if await (self.currentQueueItem?.wasSongEnjoyed == false) {
                    if let fetchedTrack = await self.currentQueueItem?.Track as? FetchedTrack {
                        RecentlyPlayedManager.prependRecentTrack(track: fetchedTrack)
                    } else if let importedTrack = await self.currentQueueItem?.Track as? ImportedTrack {
                        RecentlyPlayedManager.prependRecentTrack(track: FetchedTrack(from: importedTrack))
                    }
                }
                await self.currentQueueItem?.userEnjoyedSong()
                await self.trySuggestingPlaylistCreation()
            }
        } else {
            self.durationSeconds = 0.9
        }
        withAnimation {
            self.elapsedNormal = self.elapsedTime / self.durationSeconds
        }
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
