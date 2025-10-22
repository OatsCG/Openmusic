//
//  PMPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func prime_next_song() {
        var next5songs: ArraySlice<QueueItem> = trackQueue.prefix(5)
        if let cqi = currentQueueItem {
            next5songs.insert(cqi, at: 0)
        }
        let firstDownloaded: QueueItem? = next5songs.first(where: { $0.isDownloaded && $0.primeStatus == .waiting })
        
        if let firstDownloaded {
            Task {
                await firstDownloaded.prime_object(playerManager: self)
            }
        } else {
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
    
    func prime_current_song(continueCurrent: Bool = false) {
        Task {
            await self.currentQueueItem?.prime_object(playerManager: self, continueCurrent: continueCurrent)
        }
    }
    
    func is_current_item_ready() -> Bool {
        currentQueueItem?.isReady() ?? true
    }
    
    func is_next_item_ready() -> Bool {
        if let next = trackQueue.first,
           next.queueItemPlayer == nil || !next.isReady() {
            return false
        }
        return true
    }
    
    func modifyEQs(index: Int, value: Double) {
        currentQueueItem?.audio_AVPlayer?.player.modifyEQ(index: index, value: value)
        for item in sessionHistory {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.modifyEQ(index: index, value: value)
            }
        }
        for item in trackQueue {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.modifyEQ(index: index, value: value)
            }
        }
    }
    
    func resetEQs() {
        let wasPlaying = isPlaying
        currentQueueItem?.audio_AVPlayer?.player.resetEQ(playerManager: self)
        for item in sessionHistory {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.resetEQ(playerManager: self)
            }
        }
        for item in trackQueue {
            if item.audio_AVPlayer?.isRemote == false {
                item.audio_AVPlayer?.player.resetEQ(playerManager: self)
            }
        }
        if wasPlaying {
            currentQueueItem?.audio_AVPlayer?.player.play()
        }
    }
}
