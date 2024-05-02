//
//  AEPlayerOnline.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-02.
//

import SwiftUI
import AVFoundation
import CoreAudio
import SwiftAudioPlayer
import AudioKit


@Observable class AEPlayerOnline: AEPlayer {
    var filehash: UUID
    var status: AVPlayer.Status
    var volume: Float { return self.player.volume }
    var player: AVPlayer
    var duration: Double {
        return (player.currentItem?.duration.seconds ?? Double.nan) / 2
    }
    var currentTime: Double {
        return player.currentTime().seconds
    }

    init(url: URL? = nil) {
        if (url != nil) {
            let asset = AVAsset(url: url!)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
        } else {
            self.player = AVPlayer()
        }
        self.filehash = UUID()
        self.status = .unknown
        //self.player.automaticallyWaitsToMinimizeStalling = false
    }
    init(playerItem: AVPlayerItem) {
        self.player = AVPlayer(playerItem: playerItem)
        self.filehash = UUID()
        self.status = .unknown
        //self.player.automaticallyWaitsToMinimizeStalling = false
    }
    
    func amplitudeChart() -> [Float]? {
        return nil
    }
    
    func modifyEQ(index: Int, value: Double) {
        return
    }
    
    func resetEQ(playerManager: PlayerManager) {
        return
    }
    
    func play() {
        //self.player.play()
        print(self.player.currentItem?.loadedTimeRanges)
        self.player.playImmediately(atRate: 1.0)
    }
    func pause() {
        print(self.player.currentItem?.loadedTimeRanges)
        self.player.pause()
    }
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.player.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) {_ in
            completionHandler(true)
        }
    }
    func has_file() -> Bool {
        return self.player.currentItem != nil
    }
    func preroll(parent: PlayerEngine, completion: @escaping (Bool) -> Void) {
        if (parent.isReady) {
            self.player.cancelPendingPrerolls()
            completion(true)
            return
        }
        parent.statusObservation = self.player.observe(\.status, options: [.new]) { (player, change) in
            if player.status == .readyToPlay {
                print("STATUS READY STATUS READY")
                self.status = .readyToPlay
                parent.statusObservation?.invalidate()
                player.cancelPendingPrerolls()
                let currentRate: Float = player.rate
                player.rate = 0
                player.preroll(atRate: 1.0) { prerollSuccess in
                    player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { success in
                        player.rate = currentRate
                        parent.isReady = true
                        completion(true)
                        
                    }
                }
            } else if player.status == .failed {
                print("STATUS FAILED STATUS FAILED")
                self.status = .failed
            }
        }
    }
    func setVolume(_ to: Float) {
        self.player.volume = min(max(to, 0), 1)
    }
}
