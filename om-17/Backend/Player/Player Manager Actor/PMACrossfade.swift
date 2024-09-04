//
//  PMACrossfade.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
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
            
            try? await Task.sleep(nanoseconds: 1000)
        }
    }


}
