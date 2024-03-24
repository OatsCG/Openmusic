//
//  PMPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func prime_next_song() {
        //PREQUEUE THE NEXT 5 SONGS
        for track in self.trackQueue.prefix(5) {
            track.prime_object(playerManager: self)
        }
    }
    
    func prime_current_song(continueCurrent: Bool = false) {
        if (self.currentQueueItem != nil) {
            self.currentQueueItem!.prime_object(playerManager: self, continueCurrent: continueCurrent)
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
