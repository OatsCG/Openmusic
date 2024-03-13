//
//  QueueItem.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-14.
//

import Foundation
import AVFoundation
import SwiftUI

@Observable class QueueItem: Hashable {
    var queueID: UUID
    var Track: any Track
    var fetchedPlayback: FetchedPlayback? = nil
    var queueItemPlayer: (any PlayerEngineProtocol)? = nil
    var audio_AVPlayer: PlayerEngine? = nil
    var video_AVPlayer: VideoPlayerEngine? = nil
    var explicit: Bool = false
    var isVideo: Bool = false
    var currentlyPriming: Bool = false
    var wasSongEnjoyed: Bool = false
    
    init(from: any Track, explicit: Bool? = nil) {
        self.queueID = UUID()
        self.Track = from
        self.explicit = (explicit != nil ? explicit! : (from.Playback_Explicit != nil))
        self.setVideo(to: false)
    }
    
    init(from: QueueItem) {
        self.queueID = UUID()
        self.Track = from.Track
        self.fetchedPlayback = from.fetchedPlayback
        self.explicit = from.explicit
        
        self.audio_AVPlayer = PlayerEngine()
        
        self.video_AVPlayer = VideoPlayerEngine(ytid: from.fetchedPlayback?.YT_Video_ID)
        
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
    
    func prime_object_fresh(playerManager: PlayerManager, continueCurrent: Bool = false, seek: Bool = false) async {
        if seek {
            if let timestamp = self.queueItemPlayer?.currentTime {
                self.clearPlayback()
                await self.prime_object(playerManager: playerManager, position: timestamp)
            }
        } else {
            self.clearPlayback()
            await self.prime_object(playerManager: playerManager)
        }
    }
    
    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
        if (self.currentlyPriming) {
            return
        }
        if DownloadManager.shared.is_downloaded(self, explicit: self.explicit) {
            if self.audio_AVPlayer?.isRemote == true {
                if self.queueID != playerManager.currentQueueItem?.queueID {
                    self.clearPlayback()
                }
            }
        }
        self.currentlyPriming = true
        if self.queueItemPlayer == nil {
            Task.detached {
                var url: URL? = nil
                var isRemote: Bool = true
                if (self.isVideo == false) {
                    //getting audio url
                    if DownloadManager.shared.is_downloaded(self, explicit: self.explicit) {
                        url = DownloadManager.shared.get_stored_location(PlaybackID: self.explicit ? self.Track.Playback_Explicit! : self.Track.Playback_Clean!)
                        isRemote = false
                    } else {
                        self.fetchedPlayback = try? await fetchPlaybackData(PlaybackID: self.explicit ? self.Track.Playback_Explicit! : self.Track.Playback_Clean!)
                        url = URL(string: self.fetchedPlayback?.Playback_Audio_URL ?? "")
                    }
                }
                if url != nil {
                    self.audio_AVPlayer = PlayerEngine(url: url, remote: isRemote)
                    DispatchQueue.main.async {
                        self.video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
                    }
                    if (self.isVideo) {
                        //self.queueItemPlayer = self.video_AVPlayer
                    } else {
                        self.queueItemPlayer = self.audio_AVPlayer
                    }
                    DispatchQueue.main.async {
                        self.queueItemPlayer?.set_volume(to: playerManager.appVolume)
                        self.queueItemPlayer?.seek(to: 0)
                        playerManager.set_currentlyPlaying(queueItem: self)
                    }
                    self.queueItemPlayer?.preroll() { success in
                        if success {
                            DispatchQueue.main.async {
                                playerManager.set_currentlyPlaying(queueItem: self)
                                if position != nil {
                                    self.queueItemPlayer!.seek(to: position!)
                                }
                            }
                        }
                    }
                }
                if (playerManager.currentQueueItem?.queueID != self.queueID) {
                    self.audio_AVPlayer?.pause()
                }
                self.currentlyPriming = false
            }
        } else {
            if position != nil {
                self.queueItemPlayer!.seek(to: position!)
                playerManager.addSuggestions()
            }
            Task.detached {
                self.queueItemPlayer!.preroll() { success in
                    if success {
                        DispatchQueue.main.async {
                            if position != nil {
                                self.queueItemPlayer!.seek(to: position!)
                            }
                            playerManager.set_currentlyPlaying(queueItem: self)
                        }
                    }
                }
                self.currentlyPriming = false
            }
        }
        return
    }
    
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(queueID)
    }

    // Define equality
    static func ==(lhs: QueueItem, rhs: QueueItem) -> Bool {
        return lhs.queueID == rhs.queueID
    }
}
