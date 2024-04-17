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

    init() {
        self.eqNode = AVAudioUnitEQ(numberOfBands: EQManager.decodeCurrentBands().count) // Assuming 10 sliders
        self.isReady = false
    }
    
    static func decodeBands(bands: String?) -> [EQBand] {
        // FORMAT: <count>C<index>!<freq>!<val>B<index>!<freq>!...
        if let bands = bands {
            let CSplit: [String] = bands.components(separatedBy: "C")
            let bands: String? = CSplit.last
            if let bands = bands {
                let bandStrings: [String] = bands.components(separatedBy: "B")
                var bandObjs: [EQBand] = []
                for band in bandStrings {
                    let bandSplit: [String] = band.components(separatedBy: "!")
                    if bandSplit.count == 3 {
                        let index: Int? = Int(bandSplit[0])
                        let freq: Float? = Float(bandSplit[1])
                        let val: Double? = Double(bandSplit[2])
                        if let index = index {
                            if let freq = freq {
                                if let val = val {
                                    bandObjs.append(EQBand(freq: freq, value: val, index: index))
                                }
                            }
                        }
                    }
                }
                return bandObjs
            }
        }
        print("band cancellable")
        return []
    }
    
    static func encodeBands(bands: [EQBand]) -> String {
        let bandCount: String = String(bands.count)
        var encodedBands: [String] = []
        for band in bands {
            let bandstr: String = "\(band.index)!\(band.freq)!\(band.value)"
            encodedBands.append(bandstr)
        }
        let joinedBands: String = encodedBands.joined(separator: "B")
        let toPush: String = "\(bandCount)C\(joinedBands)"
        return toPush
    }
    
    
    static func decodeCurrentBands(count: Int? = nil) -> [EQBand] {
        let EQBandsCurrent: String? = UserDefaults.standard.string(forKey: "EQBandsCurrent")
        let bands: [EQBand] = EQManager.decodeBands(bands: EQBandsCurrent)
        if bands.count <= 2 {
            let defaultBands: [EQBand] = defaultBands(count: 6)
            EQManager.encodeBandsToCurrent(bands: defaultBands)
            return defaultBands
        } else {
            if bands.count != count && count != nil {
                return defaultBands(count: count!)
            } else {
                return bands
            }
        }
    }
    
    static func encodeBandsToCurrent(bands: [EQBand]) {
        let encodedString: String = encodeBands(bands: bands)
        UserDefaults.standard.set(encodedString, forKey: "EQBandsCurrent")
    }
    
    // Saved Presets
    static func decodePresets() -> [EQPreset] {
        // format: <id>QCOMPONENTSPLITQ<Title>QCOMPONENTSPLITQ<EQBands>QBANDSPLITQ<id>QCOMPONENTSPLITQ<Title>QCOMPONENTSPLITQ<EQBands>QBANDSPLITQ...
        let EQPresets: String? = UserDefaults.standard.string(forKey: "EQBandsPresets")
        if EQPresets == nil {
            UserDefaults.standard.set("", forKey: "EQBandsPresets")
            return []
        }
        if let EQPresets = EQPresets {
            let splitPresets: [String] = EQPresets.components(separatedBy: "QBANDSPLITQ")
            var savedPresets: [EQPreset] = []
            for preset in splitPresets {
                let titleSplit = preset.components(separatedBy: "QCOMPONENTSPLITQ")
                if titleSplit.count == 3 {
                    let presetID: String = titleSplit[0]
                    let presetTitle: String = titleSplit[1]
                    let presetBandsString: String = titleSplit[2]
                    let presetBands: [EQBand] = EQManager.decodeBands(bands: presetBandsString)
                    savedPresets.append(EQPreset(id: presetID, name: presetTitle, bands: presetBands))
                }
            }
            return savedPresets
        }
        return []
    }
    
    static func encodePresets(presets: [EQPreset]) -> String {
        // format: <id>QCOMPONENTSPLITQ<Title>QCOMPONENTSPLITQ<EQBands>QBANDSPLITQ<id>QCOMPONENTSPLITQ<Title>QCOMPONENTSPLITQ<EQBands>QBANDSPLITQ...
        var presetStrings: [String] = []
        for preset in presets {
            let strungPreset: String = "\(preset.id)QCOMPONENTSPLITQ\(preset.name)QCOMPONENTSPLITQ\(encodeBands(bands: preset.bands))"
            presetStrings.append(strungPreset)
        }
        let strungPresets: String = presetStrings.joined(separator: "QBANDSPLITQ")
        return strungPresets
    }
    
    static func appendPreset(preset: EQPreset? = nil, title: String? = nil) {
        var presetsDecoded: [EQPreset] = decodePresets()
        if let preset = preset {
            let newPreset: EQPreset = EQPreset(name: title ?? "EQ Preset", bands: preset.bands)
            presetsDecoded.append(newPreset)
        } else {
            let decodedCurrent: [EQBand] = decodeCurrentBands()
            let newPreset: EQPreset = EQPreset(name: title ?? "EQ Preset", bands: decodedCurrent)
            presetsDecoded.append(newPreset)
        }
        let presetsNewEncoded: String = encodePresets(presets: presetsDecoded)
        UserDefaults.standard.set(presetsNewEncoded, forKey: "EQBandsPresets")
    }
    
    static func deletePreset(preset: EQPreset) {
        var decodedPresets: [EQPreset] = EQManager.decodePresets()
        decodedPresets.removeAll(where: { $0.id == preset.id })
        let encodedPresets: String = encodePresets(presets: decodedPresets)
        UserDefaults.standard.set(encodedPresets, forKey: "EQBandsPresets")
    }
    
    static func editPresetTitle(presetID: String, title: String) {
        // find preset
        let decodedPresets: [EQPreset] = EQManager.decodePresets()
        let chosenPreset: EQPreset? = decodedPresets.first(where: { $0.id == presetID })
        if let chosenPreset = chosenPreset {
            EQManager.deletePreset(preset: chosenPreset)
            EQManager.appendPreset(preset: chosenPreset, title: title)
        }
    }
    
    func setEngine(audioEngine: AVAudioEngine, playerNode: AVAudioPlayerNode) {
        self.audioEngine = audioEngine
        self.playerNode = playerNode
        self.isReady = false
        self.eqNode = AVAudioUnitEQ(numberOfBands: EQManager.decodeCurrentBands().count) // Assuming 10 sliders
        setupEQ()
    }
    
    private func setupEQ() {
        // Configure EQ bands
        let bands: [EQBand] = EQManager.decodeCurrentBands()
        for band in bands {
            if band.index < 0 {
                adjustEQBand(for: band.index, value: Float(band.value))
            } else {
                eqNode.bands[band.index].bypass = false
                eqNode.bands[band.index].filterType = .parametric
                eqNode.bands[band.index].frequency = band.freq
                eqNode.bands[band.index].bandwidth = 2
                adjustEQBand(for: band.index, value: Float(band.value))
            }
        }
        if (self.isReady == false) {
            // Insert EQ in the existing audio chain
            Task.detached { [weak self] in
                if let playerNode = self?.playerNode {
                    if let audioEngine = self?.audioEngine {
                        if let eqNode = self?.eqNode {
                            let format = playerNode.outputFormat(forBus: 0)
                            audioEngine.disconnectNodeOutput(playerNode)
                            audioEngine.attach(eqNode)
                            audioEngine.connect(playerNode, to: eqNode, format: format)
                            audioEngine.connect(eqNode, to: audioEngine.mainMixerNode, format: format)
                        }
                    }
                }
            }
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
        if sliderIndex < 0 {
            eqNode.globalGain = dbValue
        } else if (sliderIndex < eqNode.bands.count) {
            eqNode.bands[sliderIndex].gain = dbValue
        }
    }
    
    func update_EQ(enabled: Bool, playerManager: PlayerManager? = nil) {
        Task {
            if (self.isReady == false) {
                return
            }
            if (enabled == false) {
                for i in 0..<eqNode.bands.count {
                    eqNode.bands[i].gain = 0
                }
            } else {
                if (EQManager.decodeCurrentBands().count != eqNode.bands.count) {
                    if let playerManager = playerManager {
                        //playerManager.pause()
                        Task {
                            await playerManager.currentQueueItem?.prime_object_fresh(playerManager: playerManager, seek: true)
                        }
                    }
                } else {
                    for band in EQManager.decodeCurrentBands() {
                        reallyAdjustBand(for: band.index, value: Float(band.value))
                    }
                }
            }
        }
    }

}

@Observable class EQBand: Equatable {
    var freq: Float
    var value: Double
    var index: Int
    
    init(freq: Float, value: Double, index: Int) {
        self.freq = freq
        self.value = value
        self.index = index
    }
    static func == (lhs: EQBand, rhs: EQBand) -> Bool {
        return lhs.value == rhs.value
    }
}

struct EQPreset: Hashable {
    var id: String
    var name: String
    var bands: [EQBand]
    init(id: String? = nil, name: String, bands: [EQBand]) {
        self.id = UUID().uuidString
        if let id = id {
            self.id = id
        }
        self.name = name
        self.bands = bands
    }
    
    static func == (lhs: EQPreset, rhs: EQPreset) -> Bool {
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}



func currentFrequencies() -> [Float] {
    var frequencies: [Float] = []
    let currentBands: [EQBand] = EQManager.decodeCurrentBands()
    for band in currentBands {
        frequencies.append(band.freq)
    }

    return frequencies
}


func defaultEqualizer(bandCount: Int) -> [Float] {
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

func defaultBands(count: Int) -> [EQBand] {
    let freqs: [Float] = defaultEqualizer(bandCount: count - 1)
    var bands: [EQBand] = []
    bands.append(EQBand(freq: 0, value: 0.5, index: -1))
    for freq in freqs {
        let val: Double = 0.5
        let index: Int = bands.count - 1
        bands.append(EQBand(freq: freq, value: val, index: index))
    }
    return bands
}

func condense_num(n: Float) -> String {
    if n < 100 {
        return String(Int(round(n)))
    } else if n < 1000 {
        return String(Int(round(n / 10)) * 10)
    } else {
        return "\(String(Int(round(n / 1000))))K"
    }
}
