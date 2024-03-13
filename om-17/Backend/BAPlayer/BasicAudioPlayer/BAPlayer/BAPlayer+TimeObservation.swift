//
//  BasicAudioPlayer
//  BAPlayer+TimeObservation.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

extension BAPlayer {

    //TODO: Observers should stop when the playback is stopped or paused, and resumed on play.
    
    public func addTimeObserver(interval: TimeInterval, queue: DispatchQueue?, block: @escaping () -> Void) -> Any {
        let t = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        t.schedule(deadline: .now(), repeating: interval, leeway: .milliseconds(1))
        t.setEventHandler(handler: block)
        t.activate()
        return t
    }
    
    public func removeTimeObserver(_ observer: Any) {
        guard let o = observer as? DispatchSourceTimer else {
            log.info("Failed to remove observer: invalid parameter.")
            return
        }

        o.cancel()
    }
    
    /// Executes a function when the indicated playback time is reached.
    public func onPlaybackTime(_ time: TimeInterval, queue: DispatchQueue?, execute block: @escaping () -> Void) -> Any {
        return addTimeObserver(interval: 0.01, queue: queue) { [weak self] in
            guard let self = self else { return }
            let ct = self.currentTime
            if ct >= time && ct <= time + 0.1 {  block() }
        }
    }
    
}
