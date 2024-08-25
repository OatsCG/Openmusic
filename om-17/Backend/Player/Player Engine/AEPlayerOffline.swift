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


@Observable final class AEPlayerOffline: AEPlayer, Sendable {
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
            Task {
                self.player.playerNode.volume = min(max(to, 0), 1)
            }
        }
    }
}
