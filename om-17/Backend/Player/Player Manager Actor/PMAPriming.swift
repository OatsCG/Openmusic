//
//  PMAPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
    func prime_next_song() async {
        // begin prime queue
        var next5songs: ArraySlice<QueueItem> = self.trackQueue.prefix(5)
        if let cqi = self.currentQueueItem {
            next5songs.insert(cqi, at: 0)
        }
        
        // get the next downloaded unprimed song
        //let firstDownloaded: QueueItem? = next5songs.first(where: { $0.primeStatus == .waiting && $0.isDownloaded })
        var firstDownloaded: QueueItem? = nil
        for song in next5songs {
            if await song.primeStatus == .waiting, await song.isDownloaded {
                firstDownloaded = song
                break
            }
        }
        
        if let firstDownloaded = firstDownloaded {
            // instantly prime song if downloaded
            await firstDownloaded.prime_object(playerManagerActor: self)
        } else {
            // prime first remote song that needs it
            for track in next5songs {
                let primeStatus = await track.primeStatus
                if primeStatus == .waiting || primeStatus == .loading {
                    await track.prime_object(playerManagerActor: self)
                    break
                }
            }
        }
    }
    
    func prime_current_song(continueCurrent: Bool = false) async {
        print("priming current")
        await self.currentQueueItem?.prime_object(playerManagerActor: self, continueCurrent: continueCurrent)
    }
    
    func is_current_item_ready() async -> Bool {
        if let currentQueueItem = self.currentQueueItem {
            return await currentQueueItem.isReady
        } else {
            return true
        }
    }
    
    func is_next_item_ready() async -> Bool {
        if let nextQueueItem = self.trackQueue.first {
            if await nextQueueItem.isReady == true {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func resetEQs() async {
        let wasPlaying: Bool = self.isPlaying
        await self.currentQueueItem?.resetEQ(playerManagerActor: self)
        for item in self.sessionHistory {
            if await item.isDownloaded == true {
                await item.resetEQ(playerManagerActor: self)
            }
        }
        for item in self.trackQueue {
            if await item.isDownloaded == true {
                await item.resetEQ(playerManagerActor: self)
            }
        }
        if wasPlaying {
            await self.currentQueueItem?.playAVPlayer()
            //self.pause()
            //self.play()
        }
    }
}
