//
//  PlayerEngine.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation
import CoreAudio

protocol PlayerEngineProtocol: Equatable {
    var id: UUID {get set}
    var isReady: Bool {get set}
    var isSeeking: Bool {get set}
    var currentTime: Double  {get}
    func duration() -> Double
    func volume() -> Float
    func set_volume(to: Float)
    func has_file() -> Bool
    func clear_file()
    func seek(to: Double)
    func seek_to_zero()
    func preroll(completion: @escaping (_ success: Bool) -> Void)
    func playImmediately()
    func play()
    func pause()
}
extension PlayerEngineProtocol {
    func isEqual(to other: (any PlayerEngineProtocol)?) -> Bool {
        return self.id == other?.id
    }
}


@Observable class PlayerEngineAV: PlayerEngineProtocol {
    var id: UUID
    var player: AVPlayer
    var statusObservation: NSKeyValueObservation?
    var isReady: Bool = false
    var isSeeking: Bool = false
    var currentTime: Double { return self.player.currentTime().seconds }
    var context: AudioProcessingContext = AudioProcessingContext()
    static func ==(lhs: PlayerEngineAV, rhs: PlayerEngineAV) -> Bool {
        return lhs.player == rhs.player
    }
    /// Initializes  a copy of an existing PlayerEngine
    init(copy: PlayerEngineAV?) {
        self.id = UUID()
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: copy?.player.currentItem!.asset.copy() as! AVAsset))
    }
    /// Initializes a PlayerEngine loaded with `url`.
    ///
    /// `url` may be a local .m4a file, or a remote m4a encoded audio streaming link.
    init(url: URL? = nil, remote: Bool? = nil) {
        self.id = UUID()
        self.player = AVPlayer()
        if url != nil {
            let asset = AVAsset(url: url!)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
        } else {
            self.player = AVPlayer()
        }
//        Task {
//            await self.getAmplitude()
//        }
        self.player.automaticallyWaitsToMinimizeStalling = false
    }
    /// Returns the duration of the player's audio in seconds
    func duration() -> Double {
        if self.has_file() {
            return self.player.currentItem!.duration.seconds / 2
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
        self.player.volume = pow(min(max(to, 0), 1), 2)
    }
    /// Returns true if the player has an audio file attached to it
    func has_file() -> Bool {
        return self.player.currentItem != nil
    }
    /// Clears the currently attached file
    func clear_file() {
        self.player.replaceCurrentItem(with: nil)
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
        self.player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    /// Primes the player for playback, and then performs the comletion callback
    func preroll(completion: @escaping (_ success: Bool) -> Void) {
        if (self.isReady) {
            self.player.cancelPendingPrerolls()
            completion(true)
            return
        }
        self.statusObservation = self.player.observe(\.status, options: [.new]) { (player, change) in
            if player.status == .readyToPlay {
                player.cancelPendingPrerolls()
                player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                self.isReady = true
                completion(true)
                player.preroll(atRate: 1.0)
                self.statusObservation?.invalidate()
            }
        }
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
        print(self.context.amplitude)
    }
    /// Returns the amplitude of the track
//    func getAmplitude() async {
//        //print("player paused")
//        self.player.currentItem?.startsOnFirstEligibleVariant = true
//        guard let track = try? await self.player.currentItem?.asset.loadTracks(withMediaType: .audio).first else {
//            return
//        }
//
//        let audioMix = AVMutableAudioMix()
//        let params = AVMutableAudioMixInputParameters(track: track)
//        
//        
//        var callbacks = MTAudioProcessingTapCallbacks(version: kMTAudioProcessingTapCallbacksVersion_0, clientInfo: Unmanaged.passUnretained(context).toOpaque())
//        { tap, _, tapStorageOut in
//            // initialize
//        } finalize: { tap in
//            // clean up
//        } prepare: { tap, maxFrames, processingFormat in
//            // allocate memory for sound processing
//        } unprepare: { tap in
//            // deallocate memory for sound processing
//        } process: { tap, numberFrames, flags, bufferListInOut, numberFramesOut, flagsOut in
//            let contextPointer = MTAudioProcessingTapGetStorage(tap)
//            let context = Unmanaged<AudioProcessingContext>.fromOpaque(contextPointer).takeUnretainedValue()
////            guard let contextPointer = MTAudioProcessingTapGetStorage(tap) else {
////                return
////            }
//            //let context = Unmanaged<AudioProcessingContext>.fromOpaque(contextPointer).takeUnretainedValue()
//            
//            guard noErr == MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut) else {
//                return
//            }
//
//            // Calculate amplitude
//            for buffer in UnsafeMutableAudioBufferListPointer(bufferListInOut) {
//                let ptr = UnsafeMutablePointer<Float>(buffer.mData?.assumingMemoryBound(to: Float.self))
//                var sum: Float = 0.0
//                for i in 0..<Int(buffer.mDataByteSize) / MemoryLayout<Float>.size {
//                    sum += abs(ptr![i]) // Calculate the absolute sum of samples
//                }
//                let amplitude: Float = sum / Float(Int(buffer.mDataByteSize) / MemoryLayout<Float>.size)
//                // Store amplitude
//                print("AMPLITUDE: \(amplitude)")
//                AudioProcessingContext.shared.setAmplitude(amplitude)
//                //context.appendAmplitude(amplitude)
//            }
//        }
//        
//        var tap: Unmanaged<MTAudioProcessingTap>?
//        let error = MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PreEffects, &tap)
//        assert(error == noErr)
//
//        params.audioTapProcessor = tap?.takeUnretainedValue()
//        tap?.release()
//
//        audioMix.inputParameters = [params]
//        player.currentItem?.audioMix = audioMix
//    }
}

class AudioProcessingContext {
    static let shared = AudioProcessingContext()
    
    var amplitude: Float = 0
    // Add a lock for thread safety if necessary
    //let lock = NSLock()

    func setAmplitude(_ amplitude: Float) {
        //lock.lock() // Use lock for thread safety
        self.amplitude = amplitude
        //lock.unlock()
    }
}
