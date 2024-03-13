//
//  BasicAudioPlayer
//  AudioPlayerNode.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFoundation

/// An AVAudioPlayerNode wrapper that encapsulates all basic playback control functionality.
public class AudioPlayerNode {
    
    // MARK: - Properties
    
    /// Whether the playback should restart once completed.
    public var doesLoop: Bool = false
    
    /// The number of seconds required to completely play the loaded audio file.
    ///
    /// - returns: The total playback duration of the loaded audio file or 0 if no file has been loaded yet.
    public var duration: TimeInterval {
        file?.duration ?? 0
    }
    
    public weak var delegate: AudioPlayerNodeDelegate? = nil
    
    /// The underlying AVAudioPlayerNode.
    ///
    /// Interacting with it directly could cause the wrapper to behave unpredictably.
    public private(set) var node = AVAudioPlayerNode()
    
    /// The bus’s input volume.
    ///
    /// The range of valid values is 0.0 to 1.0
    public var volume: Float {
        get { node.volume }
        set { node.volume = newValue }
    }
    
    /// The playback segment's lower bound.
    public var segmentStart: TimeInterval {
        get { _playbackSegment.lowerBound }
        set { playbackSegment = newValue...segmentEnd }
    }
    
    /// The playback segment's upper bound.
    public var segmentEnd: TimeInterval {
        get { _playbackSegment.upperBound }
        set { playbackSegment = segmentStart...newValue }
    }
    
    private var _playbackSegment: ClosedRange<TimeInterval> = 0...0
    /// The portion of the audio source that will be scheduled.
    public var playbackSegment: ClosedRange<TimeInterval> {
        get { _playbackSegment }
        set {
            let start = max(0, min(newValue.lowerBound, duration))
            let end = max(0, min(newValue.upperBound, duration))

            guard start <= end else {
                log.error("Failed to set playback region: duration < 0.")
                return
            }
            
            _playbackSegment = start...end
        }
    }
    
    /// The playback point within the timeline of the track associated with the player measured in seconds.
    ///
    /// Accessing this property when the underlying AVAudioPlayerNode is not attached to an engine will raise errors.
    public var currentTime: TimeInterval {
        let currentTime: TimeInterval
        
        if let pt = node.playerTime {
            let sampleTime = pt.sampleTime - (sampleTimeOffset ?? 0)
            let playerTimeInterval = Double(sampleTime) / pt.sampleRate
            currentTime = segmentStart + playerTimeInterval
        } else if status == .paused {
            currentTime = timeElapsedBeforeStop
        } else {
            currentTime = segmentStart
        }
        
        return min(currentTime, duration)
    }
    
    public private(set) var status: Status = .noSource {
        didSet {
            delegate?.playerNodeStatusDidChange(self, from: oldValue, to: status)
        }
    }
    
    /// The loaded audio file.
    public private(set) var file: AVAudioFile? = nil
    
    /// The sample time offset.
    ///
    /// When AVAudioPlayerNode starts playing after a scheduling event its sample time is not 0 as expected.
    /// This property is used to store the sample time offset, so that it can be used to correctly calculate
    /// the current playback time.
    private var sampleTimeOffset: AVAudioFramePosition? = nil
    
    /// The playback time elapsed before pausing or stopping the node.
    private var timeElapsedBeforeStop: TimeInterval = 0
    
    /// Whether the scheduling of an audio file segment is required.
    ///
    /// If an audio file is loaded and the conditions for playback are met,
    /// the scheduling is performed automatically before starting playback.
    public private(set) var needsScheduling: Bool = true
    
    /// Whether to block the next execution of the internal completion handler.
    ///
    /// This function is reset to false when a completion handler is actually blocked.
    private var blocksNextCompletionHandler: Bool = false
    
    // MARK: - Creating a Player Node
    
    public init() {} // Make the initializer accessible from any module that imports BasicAudioPlayer
    
    // MARK: - Loading Audio Files
    
    public func load(url fileURL: URL) throws {
        let f = try AVAudioFile(forReading: fileURL)
        load(file: f)
    }
    
    public func load(file: AVAudioFile) {
        if status == .playing || status == .paused {
            stop()
        }
        
        self.file = file
        needsScheduling = true
        playbackSegment = 0...duration
        status = .ready
    }
    
    // MARK: - Scheduling
    
    /// Schedules the playing of a segment of the loaded audio file.
    ///
    /// If an audio file is loaded and the conditions for playback are met,
    /// the scheduling is performed automatically before starting playback.
    /// However, you can schedule a segment manually using this function.
    ///
    /// When no segment is specified on call, the segmentStart and segmentEnd properties are used instead.
    ///
    /// - parameter segment: A range indicating the segment starting and ending time.
    /// - parameter time: The time the segment plays.
    public func schedule(segment: ClosedRange<TimeInterval>? = nil, at time: AVAudioTime? = nil) {
        guard let file = file else {
            log.error("Scheduling failed: no audio file to schedule.")
            return
        }
        
        if let newSegment = segment {
            playbackSegment = newSegment
        }

        if segmentStart == duration { segmentStart = 0 }
        
        let startFrame = AVAudioFramePosition(segmentStart * file.fileFormat.sampleRate)
        let endFrame = AVAudioFramePosition(segmentEnd * file.fileFormat.sampleRate)
        let frameCount = AVAudioFrameCount(endFrame - startFrame)
        
        guard frameCount > 0 else {
            log.error("Scheduling failed: number of frames to schedule is <= 0.")
            return
        }
        
        node.scheduleSegment(
            file,
            startingFrame: startFrame,
            frameCount: frameCount,
            at: time,
            completionCallbackType: .dataPlayedBack) {_ in
                Task { [weak self] in
                    await self?.playbackCompletionHandler()
                }
            }
        
        node.prepare(withFrameCount: frameCount)
        needsScheduling = false
        sampleTimeOffset = nil
    }
    
    // MARK: - Controlling Playback
    
    public func play(at when: AVAudioTime? = nil) {
        guard file != nil else {
            log.error("Failed to play. No audio file is loaded.")
            return
        }
        
        guard let e = node.engine else {
            log.error("Failed to play: the node must be attached to an engine.")
            return
        }
        
        guard e.isRunning else {
            log.error("Failed to play: audio engine is stopped.")
            return
        }
        
        guard status != .playing else {
            log.debug("The player is already playing.")
            return
        }
        
        if needsScheduling { schedule(at: when) }
        
        node.play()
        
        // Collect the offset of the sample time if it is nil.
        if sampleTimeOffset == nil, let pt = node.playerTime {
            sampleTimeOffset = pt.sampleTime
        }
        
        status = .playing
    }
    
    public func pause() {
        guard status == .playing else { return }
        timeElapsedBeforeStop = currentTime
        node.pause()
        status = .paused
    }
    
    /// Stops playback and removes any scheduled events.
    public func stop() {
        guard status != .noSource else { return }
        
        if status == .ready && needsScheduling {
            log.debug("Couldn't stop the node: it is already stopped and there are no scheduled events.")
            return
        }
        
        blocksNextCompletionHandler = true
        node.stop()
        status = .ready
        needsScheduling = true
    }
    
    /// Sets the current playback time.
    ///
    /// The scheduled segment is modified when this function is called. It's new value will be time...duration.
    ///
    /// - parameter time: The time to which to seek.
    public func seek(to time: TimeInterval) {
        guard let f = file else {
            log.error("Failed to seek: no audio file is loaded.")
            return
        }
        
        segmentStart = max(0, min(time, f.duration))
        segmentEnd = f.duration
        
        if status == .playing {
            stop()
            
            if segmentStart != duration || doesLoop {
                play(at: nil)
            }
        } else if status == .paused {
            stop()
        } else if status == .ready && !needsScheduling {
            blocksNextCompletionHandler = true
            node.stop()
            needsScheduling = true
        }
    }
    
    /// Executed when the scheduled audio has been completely played.
    @MainActor
    private func playbackCompletionHandler() {
        guard !blocksNextCompletionHandler else {
            blocksNextCompletionHandler = false
            return
        }
        
        node.stop()
        status = .ready
        needsScheduling = true
        delegate?.playerNodePlaybackDidComplete(self)
        if doesLoop { play() }
    }
}
