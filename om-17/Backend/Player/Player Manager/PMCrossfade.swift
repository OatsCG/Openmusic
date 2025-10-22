//
//  PMCrossfade.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI

extension PlayerManager {
    func crossfade_check() {
        if can_crossfade() {
            if !isCrossfading {
                if elapsedTime == durationSeconds {
                    // elapsed time is reporting incorrectly
                    if isPlaying {
                        play()
                    }
                    return
                }
                if let next = trackQueue.first, is_next_item_ready() {
                    //if in range, not crossfading, song ready
                    isCrossfading = true
                    next.queueItemPlayer?.set_volume(to: 0)
                    next.queueItemPlayer?.playImmediately()
                    if !crossfadeAlbums && is_consecutive() {
                        crossfade(duration: pickCrossfadeZero()) {
                            DispatchQueue.main.async {
                                self.update_elapsed_time()
                                if self.isCrossfading {
                                    self.player_forward(continueCurrent: false)
                                    self.update_elapsed_time()
                                }
                            }
                        }
                    } else {
                        crossfade(duration: crossfadeSeconds) {
                            DispatchQueue.main.async {
                                if self.isCrossfading {
                                    self.player_forward(continueCurrent: false)
                                    self.update_elapsed_time()
                                }
                            }
                        }
                    }
                } else {
                    //if in range, not crossfading, no song next
                    end_song_check()
                }
            }
        }
    }
    
    func is_consecutive() -> Bool {
        currentQueueItem?.Track.Album.AlbumID == trackQueue.first?.Track.Album.AlbumID && (currentQueueItem?.Track.Index ?? -1) + 1 == trackQueue.first?.Track.Index
    }
    
    func in_crossfade_range(duration: Double, elapsed: Double, range: Double) -> Bool {
        duration > range && duration - elapsed < range
    }
    
    func can_crossfade() -> Bool {
        if durationSeconds == 0.9 {
            return false
        } else {
            return is_current_item_ready() && in_crossfade_range(duration: durationSeconds, elapsed: elapsedTime, range: (!crossfadeAlbums && is_consecutive()) ? pickCrossfadeZero() : crossfadeSeconds)
        }
    }
    
    func pickCrossfadeZero() -> Double {
        (trackQueue.first?.audio_AVPlayer?.isRemote ?? false) ? crossfadeZero : crossfadeZeroDownload
    }
    
    typealias TransitionCompletionHandler = () -> Void
    func crossfade(duration: Double, completion: @escaping TransitionCompletionHandler) {
        let steps = Int(duration * 1000) // Calculate steps based on duration, here it's assuming the time unit is in seconds
        var step = 0
        
        crossfadeTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { crossfadeTimer in
            DispatchQueue.main.async {
                step += 1
                self.trackQueue.first?.queueItemPlayer?.set_volume(to: self.appVolume * (Float(step) / Float(steps)))
                self.player.set_volume(to: self.appVolume - self.appVolume * (Float(step) / Float(steps)))
                if self.isCrossfading == false || step == steps {
                    self.crossfadeTimer.invalidate()
                    completion()
                }
            }
        }
    }
}
