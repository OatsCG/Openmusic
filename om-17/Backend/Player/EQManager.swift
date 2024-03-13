//
//  EQManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-12.
//

import SwiftUI

import AVFoundation

import AVFoundation

class EQManager {
    var eqNode: AVAudioUnitEQ
    var audioEngine: AVAudioEngine?
    var playerNode: AVAudioPlayerNode?
    var isReady: Bool
    var bandCount: Int = 8 // MAX 10

    init() {
        self.eqNode = AVAudioUnitEQ(numberOfBands: bandCount) // Assuming 10 sliders
        self.isReady = false
    }
    
    func setEngine(audioEngine: AVAudioEngine, playerNode: AVAudioPlayerNode) {
        self.audioEngine = audioEngine
        self.playerNode = playerNode
        self.isReady = false
        self.eqNode = AVAudioUnitEQ(numberOfBands: bandCount) // Assuming 10 sliders
        setupEQ()
    }

    private func setupEQ() {
        // Configure EQ bands
        var FREQUENCY: [Float] = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000] // 10 band
        FREQUENCY = equalizerFrequencies(bandCount: bandCount)
        for i in 0..<eqNode.bands.count {
            eqNode.bands[i].bypass = false
            eqNode.bands[i].filterType = .parametric
            eqNode.bands[i].frequency = FREQUENCY[i]
            eqNode.bands[i].bandwidth = 0.5  // ~Half an octave
            adjustEQBand(for: i, value: Float(UserDefaults.standard.double(forKey: "EQBand\(i)"))) // gain = [-12, 12] dB
        }
        if (self.isReady == false) {
            // Insert EQ in the existing audio chain
            let format = playerNode?.outputFormat(forBus: 0)
            audioEngine?.disconnectNodeOutput(playerNode!)
            audioEngine?.attach(eqNode)
            audioEngine?.connect(playerNode!, to: eqNode, format: format)
            audioEngine?.connect(eqNode, to: audioEngine!.mainMixerNode, format: format)
            self.isReady = true
        }
    }

    func adjustEQBand(for sliderIndex: Int, value: Float) {
        if (UserDefaults.standard.bool(forKey: "EQEnabled") == false) {
            return
        }
        reallyAdjustBand(for: sliderIndex, value: value)
    }
    
    func reallyAdjustBand(for sliderIndex: Int, value: Float) {
        let minDb: Float = -12.0 // Minimum dB value
        let maxDb: Float = 12.0  // Maximum dB value

        // Convert slider value (0 to 1) to dB value
        let dbValue = minDb + (maxDb - minDb) * value
        eqNode.bands[sliderIndex].gain = dbValue
    }
    
    func update_EQ(enabled: Bool) {
        if (self.isReady == false) {
            return
        }
        if (enabled == false) {
            for i in 0..<eqNode.bands.count {
                eqNode.bands[i].gain = 0
            }
        } else {
            for i in 0..<eqNode.bands.count {
                reallyAdjustBand(for: i, value: Float(UserDefaults.standard.double(forKey: "EQBand\(i)")))
                //eqNode.bands[i].gain = Float(UserDefaults.standard.double(forKey: "EQBand\(i)"))
                //print(eqNode.bands[i].gain)
            }
        }
    }

}


func equalizerFrequencies(bandCount: Int) -> [Float] {
    let minFreq: Double = 32
    let maxFreq: Double = 16000
    let ratio = pow(maxFreq / minFreq, 1.0 / Double(bandCount - 1))
    var frequencies: [Float] = []

    for i in 0..<bandCount {
        let freq = minFreq * pow(ratio, Double(i))
        frequencies.append(Float(round(freq)))
    }

    return frequencies
}
