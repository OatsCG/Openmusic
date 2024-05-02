//
//  AudioPlayerEngine.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-02.
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
