//
//  VideoPlayerEngine.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-03.
//

import SwiftUI
import YouTubePlayerKit
import Combine

@Observable class VideoPlayerEngine: PlayerEngineProtocol {
    var id: UUID
    var player: YouTubePlayer?
    var isPlaying: Bool = false
    var isReady: Bool = false
    var isSeeking: Bool = false
    var currentTime: Double = 0
    private var currentTimeSubscription: AnyCancellable?
    private var durationSubscription: AnyCancellable?
    private var currentVolume: Float = 1
    private var currentDuration: Double = 1
    
    static func ==(lhs: VideoPlayerEngine, rhs: VideoPlayerEngine) -> Bool {
        return lhs.player == rhs.player
    }
    /// Initializes  a copy of an existing PlayerEngine
    init(copy: VideoPlayerEngine?) {
        self.id = UUID()
        self.player = copy!.player
    }
    /// Initializes a PlayerEngine loaded with `url`.
    ///
    /// `url` may be a local .m4a file, or a remote m4a encoded audio streaming link.
    init(ytid: String?) {
        self.id = UUID()
        if (ytid != nil) {
            self.player = YouTubePlayer(stringLiteral: "https://youtube.com/watch?v=\(ytid!)")
            self.isReady = true
            self.durationSubscription = self.player?.durationPublisher
                .sink(receiveValue: { [weak self] duration in
                    self?.currentDuration = duration
                })
            self.currentTimeSubscription = self.player?.currentTimePublisher()
                .sink(receiveValue: { [weak self] time in
                    self?.currentTime = time
                })
        } else {
            self.player = nil
        }
    }
    
    func duration() -> Double {
        return self.currentDuration
    }
    
    func volume() -> Float {
        return self.currentVolume
    }
    
    func set_volume(to: Float) {
        //self.player?.set(volume: Int(to * 100))
        self.player?.getVolume{ [weak self] result in
            switch result {
            case .success(let volume):
                self?.currentVolume = Float(volume) / 100
            case .failure(_):
                self?.currentVolume = 0
            }
        }
    }
    
    func has_file() -> Bool {
        if (self.player != nil) {
            return true
        } else {
            return false
        }
    }
    
    func clear_file() {
        self.player = nil
        //currentTimeSubscription?.cancel()
    }
    
    func seek(to: Double) {
        self.player?.seek(to: to, allowSeekAhead: true)
    }
    
    func seek_to_zero() {
        self.player?.seek(to: 0, allowSeekAhead: true)
    }
    
    func preroll(completion: @escaping (Bool) -> Void) {
        if (self.player?.state?.isError == true) {
            //self.player?.reload()
            completion(true)
        } else {
            completion(true)
        }
    }
    
    func playImmediately() {
        self.player?.play()
    }
    
    func play() {
        self.player?.play()
        
    }
    
    func pause() {
        DispatchQueue.main.async {
            self.player?.pause()
        }
    }
    
    
}
