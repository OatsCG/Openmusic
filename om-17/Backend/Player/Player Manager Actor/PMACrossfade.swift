//
//  PMACrossfade.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
    func crossfade_check() async {
        // if crossfadeAlbums == false and consecutive
//        print("crossStatus 1: \(self.durationSeconds)")
//        print("crossStatus 2: \(await self.currentQueueItem?.duration)")
//        print("crossStatus 3: \(self.player)")
//        print("crossStatus 4: \(self.player.duration())")
        if await self.can_crossfade() {
            if !self.isCrossfading {
                if (self.elapsedTime == self.durationSeconds) {
                    // elapsed time is reporting incorrectly
                    if self.isPlaying {
                        await self.play()
                    }
                    return
                }
                if await self.is_next_item_ready() {
                    if let nextQueueItem = self.trackQueue.first {
                        //if in range, not crossfading, song ready
                        
                        await self.performCrossfade(queueItem: nextQueueItem, crossfadeAlbums: self.crossfadeAlbums, crossfadeSeconds: self.crossfadeSeconds)
                        
                        
                    }
                    
                } else {
                    //if in range, not crossfading, no song next
                    await self.end_song_check()
                }
            }
        }
    }
    
    func can_crossfade() async -> Bool {
        if self.durationSeconds == 0.9 {
            return false
        } else {
            let shouldZeroRange = await self.is_consecutive() && self.crossfadeAlbums == false
            let range = shouldZeroRange ? await self.pickCrossfadeZero() : self.crossfadeSeconds
            let cancf: Bool = await self.is_current_item_ready() && self.in_crossfade_range(duration: self.durationSeconds, elapsed: self.elapsedTime, range: range)
            return cancf
        }
    }
    
    func in_crossfade_range(duration: Double, elapsed: Double, range: Double) -> Bool {
        return duration > range && duration - elapsed < range
    }
    
    func performCrossfade(queueItem: QueueItem, crossfadeAlbums: Bool, crossfadeSeconds: Double) async {
        self.isCrossfading = true
        await queueItem.getQueueItemPlayer()?.set_volume(to: 0)
        await queueItem.getQueueItemPlayer()?.playImmediately()
        
        // if crossfadeAlbums == false and consecutive
        if crossfadeAlbums == false, await self.is_consecutive() {
            await self.crossfade(duration: self.pickCrossfadeZero())
            await self.update_elapsed_time()
            if (self.isCrossfading) {
                await self.playerForward(continueCurrent: false)
                await self.update_elapsed_time()
            }
        } else {
            await self.crossfade(duration: crossfadeSeconds)
            if (self.isCrossfading) {
                await self.playerForward(continueCurrent: false)
                await self.update_elapsed_time()
            }
        }
    }
    
    func is_consecutive() async -> Bool {
        let AlbumIDMatches: Bool = await self.currentQueueItem?.Track.Album.AlbumID == self.trackQueue.first?.Track.Album.AlbumID
        let TrackIndexMatches: Bool = await self.currentQueueItem?.Track.Index == self.trackQueue.first?.Track.Index
        return AlbumIDMatches && TrackIndexMatches
    }
    
    func pickCrossfadeZero() async -> Double {
        return await (self.trackQueue.first?.isDownloaded ?? true) ? self.crossfadeZeroDownload : self.crossfadeZero
    }
    
    
    
    func crossfade(duration: Double) async {
        let steps = Int(duration * 1000) // Calculate steps based on duration
        let stepDuration = UInt64(1_000_000) // 1 millisecond in nanoseconds
        
        for step in 0...steps {
            if !self.isCrossfading {
                break
            }
            
            let volumeFraction = Float(step) / Float(steps)
            await self.trackQueue.first?.getQueueItemPlayer()?.set_volume(to: self.appVolume * volumeFraction)
            self.player.set_volume(to: self.appVolume - self.appVolume * volumeFraction)
            
            try? await Task.sleep(nanoseconds: stepDuration)
        }
    }


}
