//
//  PMControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func play() async {
        setAudioSession()
        if currentQueueItem == nil {
            if trackQueue.isEmpty {
                if let recentTrack = RecentlyPlayedManager.getRecentTracks().first {
                    await fresh_play(track: recentTrack)
                    self.play_fade()
                }
            } else {
                await self.player_forward(userInitiated: true)
                self.play_fade()
            }
        } else {
            self.play_fade()
        }
        await prime_current_song()
    }
    
    func pause() {
        //self.setIsPlaying(to: false)
        pause_fade()
    }
    
    func player_forward(continueCurrent: Bool = false, userInitiated: Bool = false) async {
        isCrossfading = false
        didAddFromRepeat = false
        if !continueCurrent {
            //self.setIsPlaying(to: false)
            player.pause()
            player.seek_to_zero()
        }
        player = PlayerEngine()
        if let currentQueueItem = self.currentQueueItem {
            withAnimation(.easeInOut(duration: userInitiated ? 0.3 : 0.6)) {
                self.sessionHistory.append(currentQueueItem)
            }
        }
        if self.trackQueue.first != nil {
            withAnimation(.easeInOut(duration: userInitiated ? 0.3 : 0.6)) {
                self.currentQueueItem = self.trackQueue.removeFirst()
            }
        } else if self.sessionHistory.first != nil {
            self.pause()
            self.queue_start_over()
            await self.player_forward(userInitiated: userInitiated)
        }
        
        //self.try_auto_skip_if_necessary()
        
        await self.scheduleNotification()
        await self.prime_current_song(continueCurrent: continueCurrent)
        await self.prime_next_song()
    }
    
    func player_backward(userInitiated: Bool = false) async {
        isCrossfading = false
        didAddFromRepeat = false
        
        if let currentQueueItem = self.currentQueueItem {
            if (self.player.currentTime.isNaN || self.player.currentTime < 5) && self.sessionHistory.last != nil {
                //self.setIsPlaying(to: false)
                withAnimation(.easeInOut(duration: userInitiated ? 0.3 : 0.6)) {
                    self.player.pause()
                }
                self.player.seek_to_zero()
                self.player = PlayerEngine()
                withAnimation(.easeInOut(duration: userInitiated ? 0.3 : 0.6)) {
                    self.trackQueue.insert(currentQueueItem, at: 0)
                    self.currentQueueItem = self.sessionHistory.removeLast()
                }
                await self.scheduleNotification()
                await self.prime_current_song()
                await self.prime_next_song()
            } else {
                self.player.seek(to: 0)
                await self.play()
                if let first = self.trackQueue.first {
                    withAnimation(.easeInOut(duration: userInitiated ? 0.3 : 0.6)) {
                        first.audio_AVPlayer?.pause()
                        first.audio_AVPlayer?.seek_to_zero()
                    }
                }
            }
        }
        
    }
    
    func setIsPlaying(to: Bool) {
        if isPlaying != to {
            if to {
                try? audioSession.setActive(true)
            }
            withAnimation(.bouncy) {
                isPlaying = to
            }
        }
    }
}
