//
//  BasicAudioPlayer
//  AudioPlayerNodeDelegate.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

/// A protocol that describes the methods to responds to playback events.
public protocol AudioPlayerNodeDelegate: AnyObject {
    
    /// Called by the audio player node when its status changes.
    func playerNodeStatusDidChange(_ node: AudioPlayerNode,
                                   from oldStatus: AudioPlayerNode.Status,
                                   to newStatus: AudioPlayerNode.Status)
    
    /// Called by the playerNode when the playback is completed.
    func playerNodePlaybackDidComplete(_ node: AudioPlayerNode)
}
