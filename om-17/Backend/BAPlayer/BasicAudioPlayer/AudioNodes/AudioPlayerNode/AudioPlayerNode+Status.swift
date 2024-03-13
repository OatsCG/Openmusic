//
//  BasicAudioPlayer
//  AudioPlayerNode+Status.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

extension AudioPlayerNode {
    
    /// The operations that a player node might undertake.
    public enum Status {
        
        /// The player has no audio source to play.
        case noSource
        
        /// The player is stopped and ready to play.
        case ready
        
        /// The player is playing.
        case playing
        
        /// The player is paused.
        case paused
    }
    
}
