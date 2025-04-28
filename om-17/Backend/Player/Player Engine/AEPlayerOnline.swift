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
    var volume: Float { return self.player.volume }
    var player: AVPlayer
    var duration: Double {
        return (player.currentItem?.duration.seconds ?? Double.nan)
    }
    var currentTime: Double {
        return player.currentTime().seconds
    }
    private var url: URL?

    init(url: URL? = nil) {
        self.url = url
        if let url = url {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
        } else {
            self.player = AVPlayer()
        }
        self.filehash = UUID()
        self.status = .unknown
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
    }
    init(playerItem: AVPlayerItem) {
        self.player = AVPlayer(playerItem: playerItem)
        //self.duration = playerItem.duration.seconds
        self.filehash = UUID()
        self.status = .unknown
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(5)
    }
    
    func amplitudeChart() -> [Float]? {
        return nil
    }
    
    func modifyEQ(index: Int, value: Double) {
        return
    }
    
    func resetEQ(playerManager: PlayerManager) {
        return
    }
    
    func play() {
        //self.player.play()
        self.player.playImmediately(atRate: 1.0)
    }
    func pause() {
        self.player.pause()
    }
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        let wasPlaying: Bool = self.player.rate == 1
        self.player.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) {_ in
            if wasPlaying {
                self.play()
            }
            completionHandler(true)
            print(self.player.rate)
        }
    }
    func has_file() -> Bool {
        return self.player.currentItem != nil
    }
    func preroll(parent: PlayerEngine, completion: @escaping (Bool) -> Void) {
        if (parent.isReady) {
            self.player.cancelPendingPrerolls()
            completion(true)
            return
        }
        parent.statusObservation = self.player.observe(\.status, options: [.new]) { (player, change) in
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
        self.player.volume = min(max(to, 0), 1)
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
