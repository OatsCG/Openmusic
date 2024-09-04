//
//  PMAControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
    func play() async {
        self.setAudioSession()
        if (self.currentQueueItem == nil) {
            if (self.trackQueue.isEmpty) {
                if let recentTrack = RecentlyPlayedManager.getRecentTracks().first {
                    await self.fresh_play(track: recentTrack)
                    await self.play_fade()
                }
            } else {
                await self.playerForward(userInitiated: true)
                await self.play_fade()
            }
        } else {
            await self.play_fade()
        }
        await self.prime_current_song()
    }
    
    func pause() async {
        await self.pause_fade()
    }
    
    func playerForward(continueCurrent: Bool = false, userInitiated: Bool = false) async {
        self.isCrossfading = false
        self.didAddFromRepeat = false
        if (continueCurrent == false) {
            self.setIsPlaying(to: false)
            self.player.pause()
            self.player.seek_to_zero()
        }
        self.player = PlayerEngine()
        
        if (self.currentQueueItem != nil) {
            withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                self.sessionHistory.append(self.currentQueueItem!)
            }
        }
        if (self.trackQueue.first != nil) {
            
            withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                self.currentQueueItem = self.trackQueue.removeFirst()
            }
        } else if (self.sessionHistory.first != nil) {
            await self.pause()
            self.queue_start_over()
            await self.playerForward(userInitiated: userInitiated)
        }
        
        //self.try_auto_skip_if_necessary()
        await self.scheduleNotification()
        await self.prime_current_song(continueCurrent: continueCurrent)
        await self.prime_next_song()
    }
    
    func playerBackward(userInitiated: Bool = false) async {
        self.isCrossfading = false
        self.didAddFromRepeat = false
        // BAD ASYNC
        
        if (self.currentQueueItem != nil) {
            if ((self.player.currentTime.isNaN || self.player.currentTime < 5) && self.sessionHistory.last != nil) {
                self.setIsPlaying(to: false)
                self.player.pause()
                self.player.seek_to_zero()
                self.player = PlayerEngine()
                self.trackQueue.insert(self.currentQueueItem!, at: 0)
                self.currentQueueItem = self.sessionHistory.removeLast()
                await self.scheduleNotification()
                await self.prime_current_song()
                await self.prime_next_song()
            } else {
                self.player.seek(to: 0)
                await self.play()
                if (self.trackQueue.first != nil) {
                    await self.trackQueue.first?.pauseAVPlayer()
                    await self.trackQueue.first?.getAudioAVPlayer()?.seek_to_zero()
                }
            }
        }
    }
}
