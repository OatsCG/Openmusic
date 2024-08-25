//
//  AmplitudeFetcher.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-13.
//

import SwiftUI
import AVFoundation

@Observable class AmplitudeFetcher {
    var amplitudes: [Float]?
    var alreadyAttempted: Bool
    
    init() {
        self.amplitudes = nil
        self.alreadyAttempted = false
    }
    
    func try_amplitude_fetch(audioFile: AVAudioFile?) {
        if (self.alreadyAttempted == true) {
            return
        }
        self.alreadyAttempted = true
        if let audioFile = audioFile {
            let avgCount: Int = 60
            let avgRange: Int = 100
            if let amplitudes = self.getAmplitudes(audioFile: audioFile, numberOfAmplitudes: avgCount * avgRange) {
                var tempAmplitudes: [Float] = []
                for i in 0..<avgCount {
                    var thisAmp: Float = 0
                    for j in 0..<avgRange {
                        thisAmp += amplitudes[(i * avgRange) + j]
                    }
                    tempAmplitudes.append(thisAmp / Float(avgRange))
                }
                
                self.amplitudes = self.normalizeAmplitudes(tempAmplitudes)
            }
        }
    }
    
    func normalizeAmplitudes(_ amplitudes: [Float]) -> [Float] {
        guard let maxAmplitude: Float = amplitudes.max(), maxAmplitude > 0 else {
            return amplitudes
        }
        
        return amplitudes.map { $0 / maxAmplitude }
    }


    func getAmplitudes(audioFile: AVAudioFile?, numberOfAmplitudes: Int) -> [Float]? {
        guard let file = audioFile, numberOfAmplitudes > 0 else { return nil }

        do {
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false) else { return nil }
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length)) else { return nil }
            try file.read(into: buffer)

            var amplitudes: [Float] = []
            let frameLength = Int(buffer.frameLength)
            let channelData = buffer.floatChannelData?[0] // Assuming mono audio for simplicity

            let frameInterval = max(1, frameLength / numberOfAmplitudes)
            for frame in stride(from: 0, to: frameLength, by: frameInterval) {
                let amplitude = abs(channelData?[frame] ?? 0)
                amplitudes.append(amplitude)
                if amplitudes.count >= numberOfAmplitudes {
                    break
                }
            }

            return amplitudes
        } catch {
            print("Error reading audio file: \(error)")
            return nil
        }
    }
}
