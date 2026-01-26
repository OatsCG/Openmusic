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
    nonisolated let queueID: UUID
    var Track: any Track
    var fetchedPlayback: FetchedPlayback?
    var queueItemPlayer: (any PlayerEngineProtocol)?
    var audio_AVPlayer: PlayerEngine?
    var video_AVPlayer: VideoPlayerEngine?
    var explicit = false
    var isVideo = false
    var currentlyPriming = false
    var wasSongEnjoyed = false
    var primeStatus: PrimeStatus = .waiting
    var isDownloaded = false
    
    init(from: any Track, explicit: Bool? = nil) {
        queueID = UUID()
        Track = from
        self.explicit = (explicit != nil ? explicit! : (from.Playback_Explicit != nil))
        update_download_status()
        setVideo(to: false)
    }
    
    init(from: QueueItem) {
        queueID = UUID()
        Track = from.Track
        fetchedPlayback = from.fetchedPlayback
        explicit = from.explicit
        audio_AVPlayer = PlayerEngine()
        video_AVPlayer = VideoPlayerEngine(ytid: from.fetchedPlayback?.YT_Video_ID)
        update_download_status()
        
        if let avplayer = from.audio_AVPlayer, avplayer.has_file() {
            audio_AVPlayer = PlayerEngine(copy: avplayer)
        }
        setVideo(to: false)
        audio_AVPlayer?.pause()
        audio_AVPlayer?.seek_to_zero()
    }
    
    func setExplicity(to: Bool) {
        if to != explicit {
            explicit = to
            clearPlayback()
        }
    }
    
    func setVideo(to: Bool) {
        if isVideo != to { }
        if to && fetchedPlayback?.YT_Video_ID != nil {
            isVideo = true
            video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
        } else if !to {
            isVideo = false
            queueItemPlayer = audio_AVPlayer
        }
    }
    
    func clearPlayback() {
        audio_AVPlayer?.pause()
        audio_AVPlayer?.clear_file()
        video_AVPlayer?.pause()
        video_AVPlayer?.clear_file()
        fetchedPlayback = nil
        audio_AVPlayer = nil
        video_AVPlayer = nil
        queueItemPlayer = nil
        currentlyPriming = false
        update_prime_status(.waiting)
        update_download_status()
    }
    
    func isReady() -> Bool {
        if let queueItemPlayer, queueItemPlayer.isReady, !queueItemPlayer.duration().isNaN, queueItemPlayer.duration() > 0 {
            return true
        }
        return false
    }
    
    func userEnjoyedSong() {
        if !wasSongEnjoyed {
            wasSongEnjoyed = true
        }
    }
    
    func prime_object_fresh(playerManager: PlayerManager, continueCurrent: Bool = false, seek: Bool = false) {
        if !isDownloaded {
            update_prime_status(.waiting)
        }
        if seek {
            if let timestamp = queueItemPlayer?.currentTime {
                DispatchQueue.main.async {
                    self.clearPlayback()
                    Task {
                        await self.prime_object(playerManager: playerManager, position: timestamp)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.clearPlayback()
                Task {
                    await self.prime_object(playerManager: playerManager)
                }
            }
        }
    }
    
    func update_download_status() {
        Task {
            if await DownloadManager.shared.is_downloaded(Track, explicit: explicit) {
                DispatchQueue.main.async {
                    self.isDownloaded = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isDownloaded = false
                }
            }
        }
    }
    
    func update_prime_status(_ status: PrimeStatus) {
        withAnimation {
            primeStatus = status
        }
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(queueID)
    }

    nonisolated static func ==(lhs: QueueItem, rhs: QueueItem) -> Bool {
        lhs.queueID == rhs.queueID
    }
}

enum PrimeStatus {
    case waiting, loading, success, primed, failed, passed
}
