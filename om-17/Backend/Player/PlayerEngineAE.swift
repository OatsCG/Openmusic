//
//  PlayerEngineEQ.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI
import AVFoundation
import CoreAudio
import SwiftAudioPlayer
import AudioKit

@Observable class PlayerEngine: PlayerEngineProtocol {
    var id: UUID
    
    var isSeeking: Bool
    
    var player: any AEPlayer
    var statusObservation: NSKeyValueObservation?
    var isReady: Bool = false
    var currentTime: Double { return self.player.currentTime }
    var isRemote: Bool = false
    static func ==(lhs: PlayerEngine, rhs: PlayerEngine) -> Bool {
        return lhs.player.filehash == rhs.player.filehash
    }
    /// Initializes  a copy of an existing PlayerEngine
    init(copy: PlayerEngine?) {
        self.id = UUID()
        self.isSeeking = false
        if (copy?.player is AEPlayerOnline) {
            let from: AEPlayerOnline = copy?.player as! AEPlayerOnline
            self.isRemote = true
            self.player = AEPlayerOnline(playerItem: AVPlayerItem(asset: from.player.currentItem!.asset.copy() as! AVAsset))
        } else if (copy?.player is AEPlayerOffline) {
            let from: AEPlayerOffline = copy?.player as! AEPlayerOffline
            self.isRemote = false
            self.player = AEPlayerOffline(url: from.player.playerNode.file?.url)
        } else {
            self.isRemote = false
            self.player = AEPlayerOffline()
        }
    }
    /// Initializes a PlayerEngine loaded with `url`.
    ///
    /// `url` may be a local .m4a file, or a remote m4a encoded audio streaming link.
    init(url: URL? = nil, remote: Bool? = nil) {
        self.id = UUID()
        self.isSeeking = false
        self.isRemote = false
        self.player = AEPlayerOnline()
        if (remote == nil) {
            return
        }
        if (remote == false) {
            self.isRemote = false
            if url != nil {
                self.player = AEPlayerOffline(url: url!)
            } else {
                self.player = AEPlayerOffline()
            }
        } else {
            self.isRemote = true
            if url != nil {
                self.player = AEPlayerOnline(url: url!)
            } else {
                self.player = AEPlayerOnline()
            }
        }
    }
    /// Returns the duration of the player's audio in seconds
    func duration() -> Double {
        if self.has_file() {
            return self.player.duration
        } else {
            return Double.nan
        }
    }
    /// Returns the volume of the player's audio
    func volume() -> Float {
        return pow(self.player.volume, 1/2)
    }
    /// Sets the volume of the player
    func set_volume(to: Float) {
        self.player.setVolume(pow(to, 2))
    }
    /// Returns true if the player has an audio file attached to it
    func has_file() -> Bool {
        return self.player.has_file()
    }
    /// Clears the currently attached file
    func clear_file() {
        if (self.player is AEPlayerOnline) {
            let from: AEPlayerOnline = self.player as! AEPlayerOnline
            from.player.replaceCurrentItem(with: nil)
        } else {
            self.player = AEPlayerOffline()
        }
    }
    /// Seeks the player to the specified time in seconds
    func seek(to: Double) {
        self.isSeeking = true
        self.player.seek(to: CMTime(seconds: to, preferredTimescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) {[weak self] _ in
            self?.isSeeking = false
        }
    }
    /// Seeks the player to the very start of the audio file
    func seek_to_zero() {
        self.isSeeking = true
        self.player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) {[weak self] _ in
            self?.isSeeking = false
        }
    }
    /// Primes the player for playback, and then performs the comletion callback
    func preroll(completion: @escaping (_ success: Bool) -> Void) {
        self.player.preroll(parent: self, completion: completion)
    }

    /// Plays the player's audio immediately
    func playImmediately() {
        //print("player played immediately")
        self.player.play()
    }
    /// Plays the player's audio
    func play() {
        //print("player played")
        self.player.play()
    }
    /// Pauses the player's audio
    func pause() {
        //print("player paused")
        self.player.pause()
    }
    
    func update_EQ(enabled: Bool) {
        if (self.isRemote == false) {
            let thisplayer = self.player as! AEPlayerOffline
            thisplayer.eqManager.update_EQ(enabled: enabled)
            
        }
    }
}


protocol AEPlayer {
    var filehash: UUID { get set }
    var duration: Double { get } // seconds
    var currentTime: Double { get } // seconds
    var status: AVPlayer.Status { get set }
    var volume: Float { get }
    func play()
    func pause()
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)
    func has_file() -> Bool
    func modifyEQ(index: Int, value: Double)
    func resetEQ(playerManager: PlayerManager)
    func preroll(parent: PlayerEngine, completion: @escaping (_ success: Bool) -> Void)
    func setVolume(_ to: Float) -> Void
    func amplitudeChart() -> [Float]?
}


@Observable class AEPlayerOffline: AEPlayer {
    var filehash: UUID
    var status: AVPlayer.Status
    var volume: Float { return self.player.playerNode.volume }
    var player: BAPlayer
    var eqManager: EQManager
    var amplitudeFetcher: AmplitudeFetcher
    var duration: Double {
        return player.duration > 0 ? player.duration : Double.nan
    }
    var currentTime: Double {
        return player.currentTime
    }

    init(url: URL? = nil) {
        self.player = BAPlayer()
        self.eqManager = EQManager()
        self.amplitudeFetcher = AmplitudeFetcher()
        self.filehash = UUID()
        self.status = .unknown
        if (url != nil) {
            let baplayer: BAPlayer? = try? BAPlayer(url: url!)
            if baplayer != nil {
                self.player = baplayer!
                self.status = .unknown
            } else {
                self.player = BAPlayer()
                self.status = .failed
            }
        }
    }
    
    func amplitudeChart() -> [Float]? {
        if (self.eqManager.isReady) {
            return self.amplitudeFetcher.amplitudes
        }
        return nil
    }
    
    func modifyEQ(index: Int, value: Double) {
        self.eqManager.adjustEQBand(for: index, value: Float(value))
    }
    
    func resetEQ(playerManager: PlayerManager) {
        
        //self.eqManager = EQManager()
        self.eqManager.update_EQ(enabled: UserDefaults.standard.bool(forKey: "EQEnabled"), playerManager: playerManager)
        //self.eqManager.resetEQ()
    }
    
    func play() {
        if (self.eqManager.isReady) {
            self.player.play()
            
        }
    }
    func pause() {
        if (self.eqManager.isReady) {
            //self.player.playerNode.pause()
            //if (self.player.status != .playing) {
                self.player.pause()
            //}
        }
    }
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        if (self.eqManager.isReady) {
            self.player.playerNode.seek(to: TimeInterval(to.seconds))
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    func has_file() -> Bool {
        return self.player.status != .noSource
    }
    func preroll(parent: PlayerEngine, completion: @escaping (_ success: Bool) -> Void) {
        self.eqManager.update_EQ(enabled: UserDefaults.standard.bool(forKey: "EQEnabled"))
        if parent.isReady {
            completion(true)
            return
        } else {
            if (self.has_file() && self.eqManager.audioEngine == nil) {
                DispatchQueue.main.async {
                    self.eqManager.setEngine(audioEngine: self.player.engine, playerNode: self.player.playerNode.node)
                    self.amplitudeFetcher.try_amplitude_fetch(audioFile: self.player.file)
                    parent.isReady = self.has_file()
                }
            }
            completion(self.has_file())
        }
    }
    func setVolume(_ to: Float) {
        if (self.eqManager.isReady) {
            self.player.playerNode.volume = min(max(to, 0), 1)
        }
    }
}




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
        self.player.automaticallyWaitsToMinimizeStalling = false
    }
    init(playerItem: AVPlayerItem) {
        self.player = AVPlayer(playerItem: playerItem)
        self.filehash = UUID()
        self.status = .unknown
        self.player.automaticallyWaitsToMinimizeStalling = false
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
        self.player.play()
    }
    func pause() {
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






class AVAudioEngineManager {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
}
