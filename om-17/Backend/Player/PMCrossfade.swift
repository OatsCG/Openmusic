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
        if self.is_current_item_ready() && self.in_crossfade_range(duration: self.durationSeconds, elapsed: self.elapsedTime, range: (self.crossfadeAlbums == false && self.is_consecutive()) ? self.crossfadeZero : self.crossfadeSeconds) {
            if !self.isCrossfading {
                if self.trackQueue.first != nil && self.is_next_item_ready() {
                    //if in range, not crossfading, song ready
                    self.isCrossfading = true
                    self.trackQueue[0].queueItemPlayer!.set_volume(to: 0)
                    self.trackQueue[0].queueItemPlayer!.playImmediately()
                    print("starting animation: \(String(describing: self.currentQueueItem?.Track.Title)), \(self.elapsedTime), \(self.durationSeconds)")
                    // if crossfadeAlbums == false and consecutive
                    if self.crossfadeAlbums == false && self.is_consecutive() {
                        self.crossfade(duration: self.crossfadeZero) {
                            self.update_elapsed_time()
                            if (self.isCrossfading) {
                                print("stopping crossfade: \(String(describing: self.currentQueueItem?.Track.Title)), \(self.elapsedTime), \(self.durationSeconds)")
                                self.player_forward(continueCurrent: false)
                                self.update_elapsed_time()
                                print("done crossfade: \(String(describing: self.currentQueueItem?.Track.Title)), \(self.elapsedTime), \(self.durationSeconds)")
                            }
                        }
                    } else {
                        self.crossfade(duration: self.crossfadeSeconds) {
                            if (self.isCrossfading) {
                                print("stopping crossfade: \(String(describing: self.currentQueueItem?.Track.Title)), \(self.elapsedTime), \(self.durationSeconds)")
                                self.player_forward(continueCurrent: false)
                                self.update_elapsed_time()
                                print("done crossfade: \(String(describing: self.currentQueueItem?.Track.Title)), \(self.elapsedTime), \(self.durationSeconds)")
                            }
                        }
                    }
                } else {
                    //if in range, not crossfading, no song next
                    self.end_song_check()
                }
            }
        }
    }
    
    func is_consecutive() -> Bool {
        return (self.currentQueueItem?.Track.Album.AlbumID == self.trackQueue.first?.Track.Album.AlbumID && (self.currentQueueItem?.Track.Index ?? -1) + 1 == self.trackQueue.first?.Track.Index)
    }
    
    func in_crossfade_range(duration: Double, elapsed: Double, range: Double) -> Bool {
        return duration > range && duration - elapsed < range
    }
    
    typealias TransitionCompletionHandler = () -> Void
    func crossfade(duration: Double, completion: @escaping TransitionCompletionHandler) {
        let steps = Int(duration * 1000) // Calculate steps based on duration, here it's assuming the time unit is in seconds
        var step = 0
        
        self.crossfadeTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { crossfadeTimer in
            DispatchQueue.main.async {
                step += 1
                self.trackQueue[0].queueItemPlayer?.set_volume(to: self.appVolume * (Float(step) / Float(steps)))
                self.player.set_volume(to: self.appVolume - self.appVolume * (Float(step) / Float(steps)))
                if self.isCrossfading == false || step == steps {
                    self.crossfadeTimer.invalidate()
                    completion()
                }
            }
        }
    }
}
