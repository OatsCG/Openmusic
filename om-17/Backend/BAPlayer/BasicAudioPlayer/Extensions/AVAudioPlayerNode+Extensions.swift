//
//  BasicAudioPlayer
//  AVAudioPlayerNode+Extensions.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFoundation

extension AVAudioPlayerNode {
    
    public var playerTime: AVAudioTime? {
        if let nodeTime = lastRenderTime, nodeTime.isSampleTimeValid {
            return playerTime(forNodeTime: nodeTime)
        }
        
        return nil
    }
    
}
