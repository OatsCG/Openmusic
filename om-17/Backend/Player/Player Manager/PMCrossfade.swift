//
//  PMCrossfade.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func crossfade_check() {
        // if crossfadeAlbums == false and consecutive
        Task {
            if await self.can_crossfade() {
                if await !self.PMActor.isCrossfading {
                    if (self.elapsedTime == self.durationSeconds) {
                        // elapsed time is reporting incorrectly
                        if self.isPlaying {
                            self.play()
                        }
                        return
                    }
                    if self.is_next_item_ready() {
                        if let nextQueueItem = self.trackQueue.first {
                            //if in range, not crossfading, song ready
                            
                            await self.PMActor.performCrossfade(queueItem: nextQueueItem, crossfadeAlbums: self.crossfadeAlbums, crossfadeSeconds: self.crossfadeSeconds)
                            
                            
                        }
                        
                    } else {
                        //if in range, not crossfading, no song next
                        self.end_song_check()
                    }
                }
            }
        }
    }
    
    func can_crossfade() async -> Bool {
        if self.durationSeconds == 0.9 {
            return false
        } else {
            let shouldZeroRange = await self.PMActor.is_consecutive() && self.crossfadeAlbums == false
            let range = shouldZeroRange ? await self.PMActor.pickCrossfadeZero() : self.crossfadeSeconds
            let cancf: Bool = self.is_current_item_ready() && self.in_crossfade_range(duration: self.durationSeconds, elapsed: self.elapsedTime, range: range)
            return cancf
        }
    }
    
    func in_crossfade_range(duration: Double, elapsed: Double, range: Double) -> Bool {
        return duration > range && duration - elapsed < range
    }
}
