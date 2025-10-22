//
//  AEPlayerOffline.swift
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
@Observable class AEPlayerOffline: AEPlayer {
    var filehash: UUID
    var status: AVPlayer.Status
    var volume: Float { player.playerNode.volume }
    var player: BAPlayer
    var eqManager: EQManager
    var amplitudeFetcher: AmplitudeFetcher
    var duration: Double { player.duration > 0 ? player.duration : Double.nan }
    var currentTime: Double { player.currentTime }

    init(url: URL? = nil) {
        player = BAPlayer()
        eqManager = EQManager()
        amplitudeFetcher = AmplitudeFetcher()
        filehash = UUID()
        status = .unknown
        if let url {
            let baplayer: BAPlayer? = try? BAPlayer(url: url)
            if let baplayer {
                player = baplayer
                status = .unknown
            } else {
                player = BAPlayer()
                status = .failed
            }
        }
    }
    
    func amplitudeChart() -> [Float]? {
        if eqManager.isReady {
            return amplitudeFetcher.amplitudes
        }
        return nil
    }
    
    func modifyEQ(index: Int, value: Double) {
        eqManager.adjustEQBand(for: index, value: Float(value))
    }
    
    func resetEQ(playerManager: PlayerManager) {
        
        //self.eqManager = EQManager()
        eqManager.update_EQ(enabled: UserDefaults.standard.bool(forKey: "EQEnabled"), playerManager: playerManager)
        //self.eqManager.resetEQ()
    }
    
    func play() {
        if eqManager.isReady {
            player.play()
            
        }
    }
    
    func pause() {
        if eqManager.isReady {
            //self.player.playerNode.pause()
            //if (self.player.status != .playing) {
                player.pause()
            //}
        }
    }
    
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        if eqManager.isReady {
            player.playerNode.seek(to: TimeInterval(to.seconds))
            print("seek info 1 for \(to): \(self.duration)")
            print("successful seek to: \(to)")
            completionHandler(true)
        } else {
            print("FAILED seek to: \(to)")
            completionHandler(false)
        }
    }
    
    func has_file() -> Bool {
        player.status != .noSource
    }
    
    func preroll(parent: PlayerEngine, completion: @Sendable @escaping (_ success: Bool) -> Void) {
        //self.eqManager.update_EQ(enabled: UserDefaults.standard.bool(forKey: "EQEnabled"))
        eqManager.update_EQ(enabled: UserDefaults.standard.bool(forKey: "EQEnabled"))
        if parent.isReady {
            print("seek: parent is ready ready")
            completion(true)
            return
        } else {
            print("seek: parent is NOT ready")
            if has_file() && eqManager.audioEngine == nil {
                Task.detached { [weak self] in
                    if let self = self {
                        await self.eqManager.setEngine(audioEngine: self.player.engine, playerNode: self.player.playerNode.node)
                        await self.amplitudeFetcher.try_amplitude_fetch(audioFile: self.player.file)
                        DispatchQueue.main.async {
                            parent.isReady = self.has_file()
                            completion(self.has_file())
                        }
                    }
                }
            } else {
                completion(has_file())
            }
        }
    }
    
    func setVolume(_ to: Float) {
        if eqManager.isReady {
            Task {
                self.player.playerNode.volume = min(max(to, 0), 1)
            }
        }
    }
}
