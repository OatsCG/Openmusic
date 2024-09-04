//
//  PMPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func prime_next_song() {
        Task {
            await self.PMActor.prime_next_song()
            await self.updateUI()
        }
    }
    
    func is_current_item_ready() -> Bool {
        if let currentQueueItem = self.currentQueueItem {
            return currentQueueItem.isReady
        } else {
            return true
        }
    }
    
    func is_next_item_ready() -> Bool {
        if let nextQueueItem = self.trackQueue.first {
            if (nextQueueItem.isReady == true) {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func resetEQs() async {
        let wasPlaying: Bool = self.isPlaying
        await self.currentQueueItem?.resetEQ(playerManagerActor: self.PMActor)
        for item in self.sessionHistory {
            if item.isDownloaded == true {
                await item.resetEQ(playerManagerActor: self.PMActor)
            }
        }
        for item in self.trackQueue {
            if item.isDownloaded == true {
                await item.resetEQ(playerManagerActor: self.PMActor)
            }
        }
        if wasPlaying {
            await self.currentQueueItem?.playAVPlayer()
        }
    }
}
