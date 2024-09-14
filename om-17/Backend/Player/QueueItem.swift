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
    var fetchedPlayback: FetchedPlayback? = nil
    var queueItemPlayer: (any PlayerEngineProtocol)? = nil
    var audio_AVPlayer: PlayerEngine? = nil
    var video_AVPlayer: VideoPlayerEngine? = nil
    var explicit: Bool = false
    var isVideo: Bool = false
    var currentlyPriming: Bool = false
    var wasSongEnjoyed: Bool = false
    var primeStatus: PrimeStatus = .waiting
    var isDownloaded: Bool = false
    
    init(from: any Track, explicit: Bool? = nil) {
        self.queueID = UUID()
        self.Track = from
        self.explicit = (explicit != nil ? explicit! : (from.Playback_Explicit != nil))
        self.update_download_status()
        self.setVideo(to: false)
    }
    
    init(from: QueueItem) {
        self.queueID = UUID()
        self.Track = from.Track
        self.fetchedPlayback = from.fetchedPlayback
        self.explicit = from.explicit
        self.audio_AVPlayer = PlayerEngine()
        self.video_AVPlayer = VideoPlayerEngine(ytid: from.fetchedPlayback?.YT_Video_ID)
        self.update_download_status()
        
        if (from.audio_AVPlayer != nil) {
            if (from.audio_AVPlayer!.has_file()) {
                self.audio_AVPlayer = PlayerEngine(copy: from.audio_AVPlayer)
            }
        }
        self.setVideo(to: false)
        self.audio_AVPlayer?.pause()
        self.audio_AVPlayer?.seek_to_zero()
    }
    
    func setExplicity(to: Bool) {
        if to != self.explicit {
            self.explicit = to
            self.clearPlayback()
        }
    }
    
    func setVideo(to: Bool) {
        if (self.isVideo != to) {
            //self.queueItemPlayer?.pause()
        }
        if to == true && self.fetchedPlayback?.YT_Video_ID != nil {
            self.isVideo = true
            self.video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
            //self.queueItemPlayer = self.video_AVPlayer
        } else if (to == false) {
            self.isVideo = false
            self.queueItemPlayer = self.audio_AVPlayer
        }
    }
    
    func clearPlayback() {
        self.audio_AVPlayer?.pause()
        self.audio_AVPlayer?.clear_file()
        self.video_AVPlayer?.pause()
        self.video_AVPlayer?.clear_file()
        self.fetchedPlayback = nil
        self.audio_AVPlayer = nil
        self.video_AVPlayer = nil
        self.queueItemPlayer = nil
        self.currentlyPriming = false
        self.update_prime_status(.waiting)
        
        
        self.update_download_status()
    }
    
    func isReady() -> Bool {
        if queueItemPlayer != nil && self.queueItemPlayer!.isReady && !self.queueItemPlayer!.duration().isNaN && self.queueItemPlayer!.duration() > 0 {
            return true
        }
        return false
    }
    
    func userEnjoyedSong() {
        if (self.wasSongEnjoyed == false) {
            self.wasSongEnjoyed = true
        }
    }
    
    func prime_object_fresh(playerManager: PlayerManager, continueCurrent: Bool = false, seek: Bool = false) {
        if self.isDownloaded == false {
            self.update_prime_status(.waiting)
        }
        if seek {
            if let timestamp = self.queueItemPlayer?.currentTime {
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
            if await DownloadManager.shared.is_downloaded(self.Track, explicit: self.explicit) {
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
            self.primeStatus = status
        }
    }
    
    // Conform to Hashable
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.queueID)
    }

    // Define equality
    nonisolated static func ==(lhs: QueueItem, rhs: QueueItem) -> Bool {
        return lhs.queueID == rhs.queueID
    }
}



enum PrimeStatus {
    case waiting, loading, success, primed, failed, passed
}
