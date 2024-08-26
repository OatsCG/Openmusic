//
//  PMControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func play() {
        self.setAudioSession()
        if (self.currentQueueItem == nil) {
            if (self.trackQueue.isEmpty) {
                if let recentTrack = RecentlyPlayedManager.getRecentTracks().first {
                    self.fresh_play(track: recentTrack)
                    Task.detached {
                        self.play_fade()
                    }
                }
            } else {
                Task.detached {
                    self.player_forward(userInitiated: true)
                    self.play_fade()
                }
            }
        } else {
            Task.detached {
                self.play_fade()
            }
        }
        self.prime_current_song()
    }
    
    func pause() {
        //self.setIsPlaying(to: false)
        self.pause_fade()
    }
    
    func player_forward(continueCurrent: Bool = false, userInitiated: Bool = false) {
        self.isCrossfading = false
        self.didAddFromRepeat = false
        if (continueCurrent == false) {
            //self.setIsPlaying(to: false)
            self.player.pause()
            self.player.seek_to_zero()
        }
        self.player = PlayerEngine()
        // BAD ASYNC
        DispatchQueue.main.async {
            if (self.currentQueueItem != nil) {
                withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                    self.sessionHistory.append(self.currentQueueItem!)
                }
            }
            if (self.trackQueue.first != nil) {
                // BAD ASYNC
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                        self.currentQueueItem = self.trackQueue.removeFirst()
                    }
                }
            } else if (self.sessionHistory.first != nil) {
                self.pause()
                self.queue_start_over()
                self.player_forward(userInitiated: userInitiated)
            }
            
            //self.try_auto_skip_if_necessary()
            
            Task {
                self.scheduleNotification()
                self.prime_current_song(continueCurrent: continueCurrent)
                self.prime_next_song()
            }
        }
    }
    
    func player_backward(userInitiated: Bool = false) {
        self.isCrossfading = false
        self.didAddFromRepeat = false
        // BAD ASYNC
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                if (self.currentQueueItem != nil) {
                    if ((self.player.currentTime.isNaN || self.player.currentTime < 5) && self.sessionHistory.last != nil) {
                        //self.setIsPlaying(to: false)
                        self.player.pause()
                        self.player.seek_to_zero()
                        self.player = PlayerEngine()
                        self.trackQueue.insert(self.currentQueueItem!, at: 0)
                        self.currentQueueItem = self.sessionHistory.removeLast()
                        self.scheduleNotification()
                        self.prime_current_song()
                        self.prime_next_song()
                    } else {
                        self.player.seek(to: 0)
                        self.play()
                        if (self.trackQueue.first != nil) {
                            self.trackQueue.first?.audio_AVPlayer?.pause()
                            self.trackQueue.first?.audio_AVPlayer?.seek_to_zero()
                        }
                    }
                }
            }
        }
    }
    
    func setIsPlaying(to: Bool) {
        if self.isPlaying != to {
            if (to == true) {
                try? self.audioSession.setActive(true)
            }
            withAnimation(.bouncy) {
                self.isPlaying = to
            }
        }
    }
}
