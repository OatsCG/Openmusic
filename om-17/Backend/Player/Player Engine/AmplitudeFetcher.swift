//
//  AmplitudeFetcher.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-13.
//

import SwiftUI
import AVFoundation

@MainActor
@Observable class AmplitudeFetcher {
    var amplitudes: [Float]?
    var alreadyAttempted: Bool
    
    init() {
        self.amplitudes = nil
        self.alreadyAttempted = false
    }
    
    func try_amplitude_fetch(audioFile: AVAudioFile?) async {
        if (self.alreadyAttempted == true) {
            return
        }
        self.alreadyAttempted = true
        if let audioFile = audioFile {
            let avgCount: Int = 60
            let avgRange: Int = 100
            self.getAmplitudes(audioFile: audioFile, numberOfAmplitudes: avgCount * avgRange)
        }
    }
    
    func normalizeAmplitudes(_ amplitudes: [Float]) -> [Float] {
        guard let maxAmplitude: Float = amplitudes.max(), maxAmplitude > 0 else {
            return amplitudes
        }
        
        return amplitudes.map { $0 / maxAmplitude }
    }


    func getAmplitudes(audioFile: AVAudioFile?, numberOfAmplitudes: Int) {
        Task.detached { [weak self] in
            guard let file = audioFile, numberOfAmplitudes > 0 else {
                DispatchQueue.main.async { [weak self] in
                    self?.amplitudes = nil
                }
                return
            }

            do {
                guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false) else {
                    DispatchQueue.main.async { [weak self] in
                        self?.amplitudes = nil
                    }
                    return
                }
                guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length)) else {
                    DispatchQueue.main.async { [weak self] in
                        self?.amplitudes = nil
                    }
                    return
                }
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
                
                // amplitudes is made. next is formatting and normalizing.
                let avgCount: Int = 60
                let avgRange: Int = 100
                var tempAmplitudes: [Float] = []
                for i in 0..<avgCount {
                    var thisAmp: Float = 0
                    for j in 0..<avgRange {
                        thisAmp += amplitudes[(i * avgRange) + j]
                    }
                    tempAmplitudes.append(thisAmp / Float(avgRange))
                }
                let normalizeAmplitudes = await self?.normalizeAmplitudes(tempAmplitudes)
                DispatchQueue.main.async { [weak self] in
                    self?.amplitudes = normalizeAmplitudes
                }
            } catch {
                print("Error reading audio file: \(error)")
                DispatchQueue.main.async { [weak self] in
                    self?.amplitudes = nil
                }
                return
            }
        }
    }
}
