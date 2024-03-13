//
//  BasicAudioPlayer
//  BAPlayer.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import AVFoundation

/// A basic audio player built with AVAudioEngine and its accessory elements.
///
/// Under the hood, BAPlayer coordinates an audio engine and an audio player node,
/// so that the two do not need to be managed directly.
///
/// You can add an unlimited number of audio units to the player to affect the audio
/// coming out of the player node.
public class BAPlayer {
    
    // MARK: - Properties
    
    public let engine = AVAudioEngine()
    public let playerNode = AudioPlayerNode()
    
    public typealias Status = AudioPlayerNode.Status
    /// The status of the underlying audio player node. It provides information about the playback status.
    public var status: AudioPlayerNode.Status {
        playerNode.status
    }
    
    public var file: AVAudioFile? {
        playerNode.file
    }
    
    public var currentTime: TimeInterval {
        get { playerNode.currentTime }
        set { playerNode.seek(to: newValue) }
    }
    
    public var duration: TimeInterval {
        playerNode.duration
    }
    
    public var doesLoop: Bool {
        get { playerNode.doesLoop }
        set { playerNode.doesLoop = newValue }
    }
    
    /// All audio units added to the player.
    ///
    /// The order of the audio units in this array reflects the connection order.
    /// The source node of the first unit is the player node, the destination node
    /// of the last unit is the engine's main mixer node.
    public private(set) var audioUnits: [AVAudioUnit] = .init()
    
    /// A closure executed when the player node status changes.
    private var onStatusChangeHandler: ((Status) -> Void)?
    
    // MARK: - Creating a Player
    
    /// Creates a player and load the file at the specified URL.
    public convenience init(url fileURL: URL) throws {
        let f = try AVAudioFile(forReading: fileURL)
        self.init(file: f)
    }
    
    /// Creates a player and load the specified file.
    public convenience init(file: AVAudioFile) {
        self.init()
        load(file: file)
    }
    
    /// Creates a player.
    public init() {
        playerNode.delegate = self
        engine.attach(playerNode.node)
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Loading Audio Files
    
    public func load(url fileURL: URL) throws {
        let f = try AVAudioFile(forReading: fileURL)
        load(file: f)
    }
    
    public func load(file: AVAudioFile) {
        stop()
        playerNode.load(file: file)
        redoConnections()
        playerNode.schedule(at: nil)
        engine.prepare()
    }
    
    // MARK: - Controlling Playback
    
    public func play() {
        guard status != .noSource else {
            log.info("Failed to play: No audio file is loaded.")
            return
        }
        
        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                log.error("Failed to start the engine: \(error.localizedDescription)")
            }
        }
        
        playerNode.play()
    }
    
    public func pause() {
        guard status == .playing else {
            log.info("Couldn't pause the player: the player is not playing.")
            return
        }
        
        playerNode.pause()
        engine.pause()
    }
    
    /// Stops the playback and removes any scheduled events.
    ///
    /// This method does nothing when no audio file is loaded.
    public func stop() {
        guard status != .noSource else {
            log.info("Couldn't stop the player: the player is already stopped.")
            return
        }
        
        playerNode.stop()
        engine.stop()
    }
    
    // MARK: - Managing Audio Units
    
    /// Add an audio unit to the player.
    ///
    /// The unit will be placed at the end of the audio unit chain.
    public func addAudioUnit(_ unit: AVAudioUnit) {
        stop()
        
        audioUnits.append(unit)
        engine.attach(unit)
        
        guard let format = file?.processingFormat else {
            // Nodes are connected when a file is loaded.
            // If no file has been loaded yet, there is no
            // point in connecting the new audio unit.
            return
        }
        
        let mixer = engine.mainMixerNode
        
        guard let inputConnection = engine.inputConnectionPoint(for: mixer, inputBus: 0) else {
            log.error("Nodes are not connected even if a file is loaded.")
            redoConnections() // Try to correct connections.
            return
        }
        
        guard let inputNode = inputConnection.node,
              inputNode !== unit // Node is already connected to mixer.
        else { return }
        
        engine.disconnectNodeInput(mixer, bus: 0)
        engine.connect(inputNode, to: unit, fromBus: inputConnection.bus, toBus: 0, format: format)
        engine.connect(unit, to: mixer, format: format)
    }
    
    // MARK: - Managing Connections
    
    /// Disconnects all audio nodes and then connects them.
    private func redoConnections() {
        disconnectNodes()
        connectNodes()
    }
    
    /// Removes all connections.
    ///
    /// BAPlayer calls this method when all nodes need to be disconnected.
    private func disconnectNodes() {
        engine.disconnectNodeInput(engine.outputNode)
        engine.disconnectNodeInput(engine.mainMixerNode)
        
        for node in audioUnits {
            engine.disconnectNodeInput(node)
        }
    }
    
    /// Connects all audio nodes.
    ///
    /// BAPlayer calls this method when all nodes need to be connected.
    private func connectNodes() {
        guard let format = file?.processingFormat else {
            log.error("Failed to connect audio nodes: no audio file is loaded.")
            return
        }
        
        // Connecting to engine.mainMixerNode causes the engine to throw -10878.
        // It is apparently harmless.
        // https://stackoverflow.com/questions/69206206/getting-throwing-10878-when-adding-a-source-to-a-mixer
        
        if audioUnits.isEmpty {
            engine.connect(playerNode.node, to: engine.mainMixerNode, format: format)
            engine.connect(engine.mainMixerNode, to: engine.outputNode, format: format)
            return
        }
        
        engine.connect(playerNode.node, to: audioUnits.first!, format: format)
        engine.connect(audioUnits.last!, to: engine.mainMixerNode, format: format)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: format)
                
        var i: Int = 0
        while i < audioUnits.count - 1 {
            engine.connect(audioUnits[i], to: audioUnits[i + 1], format: format)
            i += 1
        }
    }
    
    // MARK: - Handling Events

    /// Adds an action to perform when the player status changes.
    public func onStatusChange(perform action: ((Status) -> Void)? = nil) {
        onStatusChangeHandler = action
    }

}

// MARK: - AudioPlayerNodeDelegate

extension BAPlayer: AudioPlayerNodeDelegate {

    public func playerNodeStatusDidChange(_ node: AudioPlayerNode,
                                          from oldStatus: AudioPlayerNode.Status,
                                          to newStatus: AudioPlayerNode.Status) {

        onStatusChangeHandler?(newStatus)
    }

    public func playerNodePlaybackDidComplete(_ node: AudioPlayerNode) {
        playerNode.segmentStart = duration
        playerNode.segmentEnd = playerNode.duration

        if !doesLoop {
            engine.stop()
        }
    }

}
