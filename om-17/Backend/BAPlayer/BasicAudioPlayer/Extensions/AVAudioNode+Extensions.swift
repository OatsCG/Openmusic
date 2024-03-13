//
//  BasicAudioPlayer
//  AVAudioNode+Extensions.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFAudio

extension AVAudioNode {
    
    // MARK: - Detaching Nodes
    
    /// Detaches the audio node from its audio engine.
    ///
    /// If the node is not attached to an audio engine this method does nothing.
    public func detach() {
        guard let engine = engine else { return }
        engine.detach(self)
    }
    
}
