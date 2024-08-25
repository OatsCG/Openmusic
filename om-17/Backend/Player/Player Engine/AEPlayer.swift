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


protocol AEPlayer {
    var filehash: UUID { get set }
    var duration: Double { get } // seconds
    var currentTime: Double { get } // seconds
    var status: AVPlayer.Status { get set }
    var volume: Float { get }
    func play()
    func pause()
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping @Sendable (Bool) -> Void)
    func has_file() -> Bool
    func modifyEQ(index: Int, value: Double)
    func resetEQ(playerManager: PlayerManager)
    func preroll(parent: PlayerEngine, completion: @escaping @Sendable (_ success: Bool) -> Void)
    func setVolume(_ to: Float) -> Void
    func amplitudeChart() -> [Float]?
}

