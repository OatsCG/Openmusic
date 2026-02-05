//
//  AEPlayerOnline.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-02.
//

import SwiftUI
import AVFoundation
import CoreAudio
import SwiftAudioPlayer
import AudioKit

@MainActor
@Observable class AEPlayerOnline: AEPlayer {
    var filehash: UUID
    var status: AVPlayer.Status
    var volume: Float { player.volume }
    var player: AVPlayer
    var duration: Double {
        player.currentItem?.duration.seconds ?? Double.nan
    }
    var currentTime: Double {
        player.currentTime().seconds
    }
    private var url: URL?

    init(url: URL? = nil) {
        self.url = url
        if let url {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
        } else {
            player = AVPlayer()
        }
        filehash = UUID()
        status = .unknown
        player.automaticallyWaitsToMinimizeStalling = false
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessLogEntry(_:)),
                                               name: .AVPlayerItemNewAccessLogEntry,
                                               object: self.player.currentItem)
    }
    
    @objc func handleAccessLogEntry(_ notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem,
              let lastEvent = playerItem.accessLog()?.events.last else {
            print("AVLOG: couldnt init. \(notification.object)")
            return
        }

        let indicatedBitrate = lastEvent.indicatedBitrate // Advertised bitrate
        let averageVideoBitrate = lastEvent.averageVideoBitrate // Average video bitrate
        let averageAudioBitrate = lastEvent.averageAudioBitrate // Average audio bitrate
        let datetime = Date().timeIntervalSince1970
        // Process the bitrate information as needed
        print("AVLOG: Indicated Bitrate: \(indicatedBitrate) bps. Time logged: \(datetime)")
        print("AVLOG: Average Video Bitrate: \(averageVideoBitrate) bps. Time logged: \(datetime)")
        print("AVLOG: Average Audio Bitrate: \(averageAudioBitrate) bps. Time logged: \(datetime)")
    }
    
    init(playerItem: AVPlayerItem) {
//        playerItem.preferredPeakBitRate = 1
        player = AVPlayer(playerItem: playerItem)
        //self.duration = playerItem.duration.seconds
        filehash = UUID()
        status = .unknown
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessLogEntry(_:)),
                                               name: .AVPlayerItemNewAccessLogEntry,
                                               object: self.player.currentItem)
        player.automaticallyWaitsToMinimizeStalling = false
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
    }
    
    func amplitudeChart() -> [Float]? {
        nil
    }
    
    func modifyEQ(index: Int, value: Double) { }
    
    func resetEQ(playerManager: PlayerManager) { }
    
    func play() {
        //self.player.play()
        player.playImmediately(atRate: 1.0)
//        self.player.currentItem?.preferredPeakBitRate = 1
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        let wasPlaying = player.rate == 1
        player.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) {_ in
            if wasPlaying {
                self.play()
            }
            completionHandler(true)
        }
    }
    
    func has_file() -> Bool {
        player.currentItem != nil
    }
    
    func preroll(parent: PlayerEngine, completion: @Sendable @escaping (Bool) -> Void) {
        if parent.isReady {
            player.cancelPendingPrerolls()
            completion(true)
            return
        }
        parent.statusObservation = player.observe(\.status, options: [.new]) { (player, change) in
            if player.status == .readyToPlay {
                print("STATUS READY STATUS READY")
                DispatchQueue.main.async {
                    self.status = .readyToPlay
                    parent.statusObservation?.invalidate()
                }
                player.cancelPendingPrerolls()
                let currentRate: Float = player.rate
                player.rate = 0
                player.preroll(atRate: 1.0) { prerollSuccess in
                    player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { success in
                        player.rate = currentRate
                        DispatchQueue.main.async {
                            parent.isReady = true
                            completion(true)
                        }
                        
                    }
                }
            } else if player.status == .failed {
                print("STATUS FAILED STATUS FAILED")
                DispatchQueue.main.async {
                    self.status = .failed
                }
            }
        }
    }
    
    func setVolume(_ to: Float) {
        player.volume = min(max(to, 0), 1)
    }
}

func fetchContentLength(myURL: URL?, callback: @escaping (Double?) -> Void) {
    if let myURL = myURL {
        var request = URLRequest(url: myURL)
        request.addValue("bytes=0-1", forHTTPHeaderField: "Range")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                callback(nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               let contentRange = httpResponse.allHeaderFields["content-range"] as? String {
                let parts = contentRange.components(separatedBy: "/")
                if let totalSize = parts.last, let size = Int(totalSize) {
                    print("FCL GOT: \(size)")
                    let ms: Double = Double((size * 8) / 130000)
                    print("FCL FORMATTED: \(ms)")
                    callback(ms)
                } else {
                    print("FCL NIL 1")
                    callback(nil)
                }
            } else {
                print("FCL NIL 2")
                callback(nil)
            }
        }
        task.resume()
    } else {
        print("FCL NIL 3")
        callback(nil)
    }
}
