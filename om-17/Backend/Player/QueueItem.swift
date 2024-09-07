//
//  QueueItem.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-14.
//

import Foundation
import AVFoundation
import SwiftUI

@MainActor
@Observable class QueueItem: Hashable {
    let queueID: UUID
    var Track: any Track
    var fetchedPlayback: FetchedPlayback? = nil
    var explicit: Bool = false
    var isVideo: Bool = false
    var currentlyPriming: Bool = false
    var wasSongEnjoyed: Bool = false
    var primeStatus: PrimeStatus = .waiting
    var isDownloaded: Bool = false
    var isReady: Bool = false
    var status: AVPlayer.Status? = nil
    var duration: Double? = nil
    private var queueItemActor: QueueItemActor
    
    init(from: any Track, explicit: Bool? = nil) async {
        self.queueID = UUID()
        self.Track = from
        var explicity: Bool = false
        if let explicit = explicit {
            explicity = explicit
        } else {
            explicity = from.Playback_Explicit != nil
        }
        self.explicit = explicity
        self.queueItemActor = await QueueItemActor(queueID: self.queueID, Track: from, fetchedPlayback: nil, explicit: explicity, audio_AVPlayer: nil)
    }
    
    init(from: QueueItem) async {
        self.queueID = UUID()
        self.Track = from.Track
        self.explicit = from.explicit
        self.queueItemActor = await QueueItemActor(queueID: self.queueID, Track: from.Track, fetchedPlayback: from.queueItemActor.fetchedPlayback, explicit: from.explicit, audio_AVPlayer: from.queueItemActor.audio_AVPlayer)
        await self.updateUI()
    }
    
    func updateUI() {
        Task {
            await self.queueItemActor.updateDownloadStatus()
            let currentlyPriming = await self.queueItemActor.currentlyPriming
            let fetchedPlayback = await self.queueItemActor.fetchedPlayback
            let primeStatus = await self.queueItemActor.primeStatus
            let isDownloaded = await self.queueItemActor.isDownloaded
            let isReady = await self.queueItemActor.isReady()
            let isVideo = await self.queueItemActor.isVideo
            let status = await self.queueItemActor.audio_AVPlayer?.player.status
            let duration = await self.queueItemActor.audio_AVPlayer?.player.duration
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.currentlyPriming = currentlyPriming
                    self.fetchedPlayback = fetchedPlayback
                    self.primeStatus = primeStatus
                    self.isDownloaded = isDownloaded
                    self.isReady = isReady
                    self.isVideo = isVideo
                    self.status = status
                    self.duration = duration
                }
            }
        }
    }
    
    func clearPlayback() async {
        self.currentlyPriming = false
        await self.queueItemActor.setCurrentlyPriming(to: false)
        await self.setPrimeStatus(.waiting)
        await self.queueItemActor.clearPlayback()
        await self.updateUI()
    }
    
    func userEnjoyedSong() {
        if (self.wasSongEnjoyed == false) {
            self.wasSongEnjoyed = true
        }
    }
    
    func prime_object_fresh(playerManagerActor: PlayerManagerActor, continueCurrent: Bool = false, seek: Bool = false) {
        Task {
            if self.isDownloaded == false {
                await self.setPrimeStatus(.waiting)
                await self.updateUI()
            }
            if seek {
                if let timestamp = await self.queueItemActor.getCurrentTimestamp() {
                    await self.clearPlayback()
                    self.prime_object(playerManagerActor: playerManagerActor, position: timestamp)
                }
            } else {
                await self.clearPlayback()
                self.prime_object(playerManagerActor: playerManagerActor)
            }
        }
    }
    
    func prime_object(playerManagerActor: PlayerManagerActor, continueCurrent: Bool = false, position: Double? = nil) {
        Task.detached { [self] in
            let primeStatus: PrimeStatus = await self.queueItemActor.primeObjectForSwitch(playerManagerActor: playerManagerActor, continueCurrent: continueCurrent, position: position)
            await self.updateUI()
            if primeStatus == .success {
                await self.setPrimeStatus(.success)
            } else if primeStatus == .failed {
                await self.setPrimeStatus(.failed)
            } else if primeStatus == .loading { // not actually loading; just used to go to this block
                await playerManagerActor.prime_next_song()
            }
            await self.updateUI()
            
            if primeStatus != .failed {
                let prerollStatus = await self.queueItemActor.prerollEngine(playerManagerActor: playerManagerActor)
                await self.updateUI()
                if primeStatus == .success {
                    await self.queueItemActor.seekIfNeeded(playerManagerActor: playerManagerActor)
                    await self.setPrimeStatus(.primed)
                    await self.updateUI()
                    await playerManagerActor.switchCurrentlyPlaying(queueItem: self)
                    await self.updateUI()
                } else if primeStatus == .failed {
                    await self.setPrimeStatus(.failed)
                    await self.updateUI()
                } else if primeStatus == .waiting { // not actually waiting; just used to go to this block
                    await self.updateUI()
                }
            }
            
            if await playerManagerActor.currentQueueItem?.queueID != self.queueItemActor.queueID {
                await self.queueItemActor.audio_AVPlayer?.pause()
                await self.updateUI()
            }
            await self.queueItemActor.setCurrentlyPriming(to: false)
            await self.updateUI()
            
            await playerManagerActor.prime_next_song()
            await self.updateUI()
        }
        return
    }
    
    // Conform to Hashable
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(queueID)
    }

    // Define equality
    nonisolated static func ==(lhs: QueueItem, rhs: QueueItem) -> Bool {
        return lhs.queueID == rhs.queueID
    }
}


// SET METHODS
extension QueueItem {
    func setCurrentlyPriming(to: Bool) {
        self.currentlyPriming = to
    }
    func setExplicity(to: Bool) {
        Task {
            if to != self.explicit {
                self.explicit = to
                await self.queueItemActor.setExplicity(to: to)
                await self.clearPlayback()
            }
        }
    }
    func setVideo(to: Bool) {
        Task {
            await self.queueItemActor.setVideo(to: to)
            await self.updateUI()
        }
        return
    }
    func setPrimeStatus(_ to: PrimeStatus) async {
//        withAnimation {
//            self.primeStatus = status
//        }
        await self.queueItemActor.update_prime_status(to)
        await self.updateUI()
    }
}

// GET METHODS
extension QueueItem {
    func getQueueItemPlayer() async -> (any PlayerEngineProtocol)? {
        return await self.queueItemActor.queueItemPlayer
    }
    
    func getAudioAVPlayer() async -> PlayerEngine? {
        return await self.queueItemActor.audio_AVPlayer
    }
    func getVideoAVPlayer() async -> VideoPlayerEngine? {
        return await self.queueItemActor.video_AVPlayer
    }
}



// actions on queueItemActor
extension QueueItem {
    func pauseAVPlayer() async {
        await self.queueItemActor.queueItemPlayer?.pause()
    }
    
    func playAVPlayer() async {
        await self.queueItemActor.queueItemPlayer?.play()
    }
    
    func resetEQ(playerManagerActor: PlayerManagerActor) async {
        await self.queueItemActor.audio_AVPlayer?.player.resetEQ(playerManagerActor: playerManagerActor)
    }
}







enum PrimeStatus {
    case waiting, loading, success, primed, failed, passed
}
