//
//  PMPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func prime_next_song() {
        // begin prime queue
        var next5songs: ArraySlice<QueueItem> = self.trackQueue.prefix(5)
        if let cqi = self.currentQueueItem {
            next5songs.insert(cqi, at: 0)
        }
        
        // instantly prime downloaded songs
        let firstDownloaded: QueueItem? = next5songs.first(where: { $0.isDownloaded && $0.primeStatus == .waiting })
        
        if let firstDownloaded = firstDownloaded {
            Task {
                await firstDownloaded.prime_object(playerManager: self)
            }
        } else {
            // prime first remote song that needs it
            for track in next5songs {
                if track.primeStatus == .waiting || track.primeStatus == .loading {
                    Task {
                        await track.prime_object(playerManager: self)
                    }
                    break
                }
            }
        }
    }
    
    //func
    
    func prime_current_song(continueCurrent: Bool = false) {
        if (self.currentQueueItem != nil) {
            Task {
                await self.currentQueueItem?.prime_object(playerManager: self, continueCurrent: continueCurrent)
            }
        }
    }
    
    func is_current_item_ready() -> Bool {
        if (self.currentQueueItem == nil) {
            return true
        } else {
            return self.currentQueueItem!.isReady()
        }
    }
    
    func is_next_item_ready() -> Bool {
        if (self.trackQueue.first == nil) {
            return true
        } else {
            if (self.trackQueue[0].queueItemPlayer != nil) {
                if (self.trackQueue[0].isReady() == true) {
                    return true
                }
            }
        }
        return false
    }
    
    func resetEQs() {
        let wasPlaying: Bool = self.isPlaying
        print("reseting. wasPlaying: \(wasPlaying)")
        self.currentQueueItem?.audio_AVPlayer?.player.resetEQ(playerManager: self)
        for item in self.sessionHistory {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.resetEQ(playerManager: self)
            }
        }
        for item in self.trackQueue {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.resetEQ(playerManager: self)
            }
        }
        print("still? \(self.isPlaying)")
        if wasPlaying {
            self.currentQueueItem?.audio_AVPlayer?.player.play()
            //self.pause()
            //self.play()
        }
    }
}
