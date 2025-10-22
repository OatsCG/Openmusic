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

@MainActor
@Observable class PlayerEngine: PlayerEngineProtocol {
    var id: UUID
    
    var isSeeking: Bool
    
    var player: any AEPlayer
    var statusObservation: NSKeyValueObservation?
    var isReady: Bool = false
    var currentTime: Double { player.currentTime }
    var isRemote: Bool = false
    static func ==(lhs: PlayerEngine, rhs: PlayerEngine) -> Bool {
        lhs.player.filehash == rhs.player.filehash
    }
    
    /// Initializes  a copy of an existing PlayerEngine
    init(copy: PlayerEngine?) {
        id = UUID()
        isSeeking = false
        if let from = copy?.player as? AEPlayerOnline {
            isRemote = true
            player = AEPlayerOnline(playerItem: AVPlayerItem(asset: from.player.currentItem?.asset.copy() as? AVAsset ?? AVAsset()))
        } else if let from = copy?.player as? AEPlayerOffline {
            isRemote = false
            player = AEPlayerOffline(url: from.player.playerNode.file?.url)
        } else {
            isRemote = false
            player = AEPlayerOffline()
        }
    }
    
    /// Initializes a PlayerEngine loaded with `url`.
    ///
    /// `url` may be a local .m4a file, or a remote m4a encoded audio streaming link.
    init(url: URL? = nil, remote: Bool? = nil) {
        id = UUID()
        isSeeking = false
        isRemote = false
        player = AEPlayerOnline()
        if remote == nil {
            return
        }
        if remote == false {
            isRemote = false
            if let url {
                player = AEPlayerOffline(url: url)
            } else {
                player = AEPlayerOffline()
            }
        } else {
            isRemote = true
            if let url {
                player = AEPlayerOnline(url: url)
            } else {
                player = AEPlayerOnline()
            }
        }
    }
    
    /// Returns the duration of the player's audio in seconds
    func duration() -> Double {
        if has_file() {
            return player.duration
        } else {
            return Double.nan
        }
    }
    
    /// Returns the volume of the player's audio
    func volume() -> Float {
        pow(player.volume, 1/2)
    }
    
    /// Sets the volume of the player
    func set_volume(to: Float) {
        player.setVolume(pow(to, 2))
    }
    
    /// Returns true if the player has an audio file attached to it
    func has_file() -> Bool {
        player.has_file()
    }
    
    /// Clears the currently attached file
    func clear_file() {
        if player is AEPlayerOnline {
            let from: AEPlayerOnline? = self.player as? AEPlayerOnline
            from?.player.replaceCurrentItem(with: nil)
        } else {
            player = AEPlayerOffline()
        }
    }
    
    /// Seeks the player to the specified time in seconds
    func seek(to: Double) {
        print("SEEKING TO: \(to)")
        isSeeking = true
        player.seek(to: CMTime(seconds: to, preferredTimescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) {[weak self] _ in
            self?.isSeeking = false
        }
    }
    
    /// Seeks the player to the very start of the audio file
    func seek_to_zero() {
        isSeeking = true
        player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) {[weak self] _ in
            self?.isSeeking = false
        }
    }
    
    /// Primes the player for playback, and then performs the comletion callback
    func preroll(completion: @escaping (_ success: Bool) -> Void) {
        player.preroll(parent: self, completion: completion)
    }

    /// Plays the player's audio immediately
    func playImmediately() {
        player.play()
    }
    
    /// Plays the player's audio
    func play() {
        player.play()
    }
    
    /// Pauses the player's audio
    func pause() {
        player.pause()
    }
    
    @MainActor func update_EQ(enabled: Bool) {
        if !isRemote {
            let thisplayer: AEPlayerOffline? = player as? AEPlayerOffline
            thisplayer?.eqManager.update_EQ(enabled: enabled)
        }
    }
}
