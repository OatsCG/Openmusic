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
    var explicit: Bool = false
    var isVideo: Bool = false
    var currentlyPriming: Bool = false
    var wasSongEnjoyed: Bool = false
    var primeStatus: PrimeStatus = .waiting
    var isDownloaded: Bool = false
    var isReady: Bool = false
    
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
    
    func updateUI() async {
        await self.queueItemActor.updateDownloadStatus()
        self.currentlyPriming = await self.queueItemActor.currentlyPriming
        self.primeStatus = await self.queueItemActor.primeStatus
        self.isDownloaded = await self.queueItemActor.isDownloaded
        self.isReady = await self.queueItemActor.isReady()
        self.isVideo = await self.queueItemActor.isVideo
        return
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
    
    func prime_object_fresh(playerManager: PlayerManager, continueCurrent: Bool = false, seek: Bool = false) {
        Task {
            if self.isDownloaded == false {
                await self.setPrimeStatus(.waiting)
                await self.updateUI()
            }
            if seek {
                if let timestamp = await self.queueItemActor.getCurrentTimestamp() {
                    await self.clearPlayback()
                    self.prime_object(playerManager: playerManager, position: timestamp)
                }
            } else {
                await self.clearPlayback()
                self.prime_object(playerManager: playerManager)
            }
        }
    }
    
    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) {
        Task.detached { [self] in
            let primeStatus: PrimeStatus = await self.queueItemActor.primeObjectForSwitch(playerManager: playerManager, continueCurrent: continueCurrent, position: position)
            await self.updateUI()
            if primeStatus == .success {
                await self.setPrimeStatus(.success)
            } else if primeStatus == .failed {
                await self.setPrimeStatus(.failed)
            } else if primeStatus == .loading { // not actually loading; just used to go to this block
                playerManager.prime_next_song()
            }
            await self.updateUI()
            
            if primeStatus != .failed {
                let prerollStatus = await self.queueItemActor.prerollEngine(playerManager: playerManager)
                await self.updateUI()
                if primeStatus == .success {
                    await self.queueItemActor.seekIfNeeded(playerManager: playerManager)
                    await self.setPrimeStatus(.primed)
                    await self.updateUI()
                    playerManager.switchCurrentlyPlaying(queueItem: self)
                    await self.updateUI()
                } else if primeStatus == .failed {
                    await self.setPrimeStatus(.failed)
                    await self.updateUI()
                } else if primeStatus == .waiting { // not actually waiting; just used to go to this block
                    await self.updateUI()
                }
            }
            
            if await playerManager.currentQueueItem?.queueID != self.queueItemActor.queueID {
                await self.queueItemActor.audio_AVPlayer?.pause()
                await self.updateUI()
            }
            await self.queueItemActor.setCurrentlyPriming(to: false)
            await self.updateUI()
            
            playerManager.prime_next_song()
            await playerManager.addSuggestions()
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







enum PrimeStatus {
    case waiting, loading, success, primed, failed, passed
}
