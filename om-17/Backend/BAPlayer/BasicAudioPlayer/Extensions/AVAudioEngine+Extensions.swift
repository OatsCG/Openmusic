//
//  BasicAudioPlayer
//  AVAudioEngine+Extensions.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFAudio

extension AVAudioEngine {
    
    public func attach(_ nodes: Set<AVAudioNode>) {
        for n in nodes { attach(n) }
    }
    
}
