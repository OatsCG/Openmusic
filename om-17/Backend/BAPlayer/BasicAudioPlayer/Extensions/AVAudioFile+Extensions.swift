//
//  BasicAudioPlayer
//  AVAudioFile+Extensions.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFoundation

extension AVAudioFile {
    
    /// The duration of the audio file measured in seconds.
    public var duration: TimeInterval {
        Double(length) / fileFormat.sampleRate
    }
    
}
