//
//  PMAControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
    func play() async {
        print("play 1")
        self.setAudioSession()
        print("play 2")
        if (self.currentQueueItem == nil) {
            if (self.trackQueue.isEmpty) {
                if let recentTrack = RecentlyPlayedManager.getRecentTracks().first {
                    print("play 3")
                    await self.fresh_play(track: recentTrack)
                    print("play 4")
                    await self.play_fade()
                    print("play 5")
                }
            } else {
                print("play 6")
                await self.playerForward(userInitiated: true)
                print("play 7")
                await self.play_fade()
                print("play 8")
            }
        } else {
            print("play 9")
            await self.play_fade()
            print("play 10")
        }
        print("play 11")
        await self.prime_current_song()
        print("play 12")
    }
    
    func pause() async {
        await self.pause_fade()
    }
    
    func playerForward(continueCurrent: Bool = false, userInitiated: Bool = false) async {
        self.isCrossfading = false
        self.didAddFromRepeat = false
        if (continueCurrent == false) {
            self.setIsPlaying(to: false)
            print("PAUSED AT #7")
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
            print("PAUSED AT #3")
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
