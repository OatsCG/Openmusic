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


@Observable final class AEPlayerOnline: AEPlayer, Sendable {
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
    private var url: URL?

    init(url: URL? = nil) {
        self.url = url
        if (url != nil) {
            let asset = AVURLAsset(url: url!)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
        } else {
            self.player = AVPlayer()
        }
        self.filehash = UUID()
        self.status = .unknown
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
    }
    init(playerItem: AVPlayerItem) {
        self.player = AVPlayer(playerItem: playerItem)
        //self.duration = playerItem.duration.seconds
        self.filehash = UUID()
        self.status = .unknown
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
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
        self.player.playImmediately(atRate: 1.0)
    }
    func pause() {
        self.player.pause()
    }
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping @Sendable (Bool) -> Void) {
        self.player.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) {_ in
            completionHandler(true)
        }
    }
    func has_file() -> Bool {
        return self.player.currentItem != nil
    }
    func preroll(parent: PlayerEngine) async -> Bool {
        if parent.isReady {
            self.player.cancelPendingPrerolls()
            return true
        }
        
        return await withCheckedContinuation { continuation in
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
                            continuation.resume(returning: true)
                        }
                    }
                } else if player.status == .failed {
                    print("STATUS FAILED STATUS FAILED")
                    self.status = .failed
                    continuation.resume(returning: false)
                }
            }
        }
    }

    func setVolume(_ to: Float) {
        self.player.volume = min(max(to, 0), 1)
    }
}

