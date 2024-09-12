////
////  QueueItemActor.swift
////  om-17
////
////  Created by Charlie Giannis on 2024-08-26.
////
//
//import SwiftUI
//
//actor QueueItemActor {
//    let queueID: UUID
//    var Track: any Track
//    var fetchedPlayback: FetchedPlayback? = nil
//    var queueItemPlayer: (any PlayerEngineProtocol)? = nil
//    var audio_AVPlayer: PlayerEngine? = nil
//    var video_AVPlayer: VideoPlayerEngine? = nil
//    var explicit: Bool = false
//    var isVideo: Bool = false
//    var currentlyPriming: Bool = false
//    var primeStatus: PrimeStatus = .waiting
//    var isDownloaded: Bool = false
//    var formulatedURL: URL? = nil
//    
//    init(queueID: UUID, Track: any Track, fetchedPlayback: FetchedPlayback?, explicit: Bool, audio_AVPlayer: PlayerEngine?) async {
//        self.queueID = queueID
//        self.Track = Track
//        self.fetchedPlayback = fetchedPlayback
//        self.explicit = explicit
//        self.audio_AVPlayer = PlayerEngine()
//        self.video_AVPlayer = VideoPlayerEngine(ytid: fetchedPlayback?.YT_Video_ID)
//        await self.updateDownloadStatus()
//        
//        if let audio_AVPlayer = audio_AVPlayer {
//            if audio_AVPlayer.has_file() {
//                self.audio_AVPlayer = PlayerEngine(copy: audio_AVPlayer)
//            }
//        }
//        self.isVideo = false
//        print("PAUSED AT #8 (reinitialized)")
//        self.audio_AVPlayer?.pause()
//        self.audio_AVPlayer?.seek_to_zero()
//    }
//    
//    func updateDownloadStatus() async {
//        if await DownloadManager.shared.is_downloaded(self.Track, explicit: self.explicit) {
//            self.isDownloaded = true
//        } else {
//            self.isDownloaded = false
//        }
//    }
//    
//    func isReady() -> Bool {
//        if let queueItemPlayer = self.queueItemPlayer {
//            if queueItemPlayer.isReady && !queueItemPlayer.duration().isNaN {
//                if queueItemPlayer.duration() > 0 {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    func clearPlayback() async {
//        self.audio_AVPlayer?.pause()
//        self.audio_AVPlayer?.clear_file()
//        self.video_AVPlayer?.pause()
//        self.video_AVPlayer?.clear_file()
//        self.fetchedPlayback = nil
//        self.audio_AVPlayer = nil
//        self.video_AVPlayer = nil
//        self.queueItemPlayer = nil
//        self.currentlyPriming = false
//        self.formulatedURL = nil
//        self.update_prime_status(.waiting)
//        
//        await self.updateDownloadStatus()
//    }
//    
//    func update_prime_status(_ status: PrimeStatus) {
//        self.primeStatus = status
//    }
//    
//    private func clearIfDownloaded(playerManagerActor: PlayerManagerActor) async {
//        if await DownloadManager.shared.is_downloaded(Track, explicit: self.explicit) {
//            if self.audio_AVPlayer?.isRemote == true {
//                if await self.queueID != playerManagerActor.currentQueueItem?.queueID {
//                    await self.clearPlayback()
//                }
//            }
//        }
//    }
//    
//    private func primeEngineForPreroll(playerManagerActor: PlayerManagerActor, url: URL, isRemote: Bool) async {
//        self.audio_AVPlayer = PlayerEngine(url: url, remote: isRemote)
//        self.video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
//        if (self.isVideo == true) {
//            //self.queueItemPlayer = self.video_AVPlayer
//        } else {
//            self.queueItemPlayer = self.audio_AVPlayer
//        }
//        await self.queueItemPlayer?.set_volume(to: playerManagerActor.appVolume)
//        self.queueItemPlayer?.seek(to: 0)
//    }
//    
//    func seekIfNeeded(playerManagerActor: PlayerManagerActor, position: Double? = nil) async {
//        if let position = position {
//            self.queueItemPlayer?.seek(to: position)
//            if await (playerManagerActor.isPlaying) {
//                self.queueItemPlayer?.play()
//            }
//        }
//    }
//    
//    private func fetchPlaybackDataIfNeeded() async -> FetchedPlayback? {
//        self.update_prime_status(.loading)
//        await self.updateDownloadStatus()
//        if !self.isDownloaded {
//            return try? await fetchPlaybackData(playbackID: self.explicit ? self.Track.Playback_Explicit! : self.Track.Playback_Clean!)
//        }
//        return nil
//    }
//    
//    private func formulateFreshPlaybackURL(playerManagerActor: PlayerManagerActor) async {
//        let playbackData: FetchedPlayback? = await self.fetchPlaybackDataIfNeeded()
//        
//        await playerManagerActor.prime_next_song()
//        
//        //getting audio url
//        var url: URL? = nil
//        if (self.isVideo == false) {
//            if self.isDownloaded {
//                url = await DownloadManager.shared.get_stored_location(PlaybackID: self.explicit ? self.Track.Playback_Explicit! : self.Track.Playback_Clean!)
//            } else {
//                self.fetchedPlayback = playbackData
//                url = URL(string: self.fetchedPlayback?.Playback_Audio_URL ?? "")
//            }
//        }
//        self.formulatedURL = url
//    }
//    
//    func prerollEngine(playerManagerActor: PlayerManagerActor) async -> PrimeStatus {
//        if let formulatedURL = self.formulatedURL {
//            await self.primeEngineForPreroll(playerManagerActor: playerManagerActor, url: formulatedURL, isRemote: !self.isDownloaded)
//            let successfulPreroll = await self.queueItemPlayer?.preroll()
//            if successfulPreroll == true {
//                return .primed
//            } else {
//                return .failed
//            }
//        } else {
//            return .waiting
//        }
//    }
//    
//    func primeFreshQueueItemPlayer(playerManagerActor: PlayerManagerActor) async -> Bool {
//        await self.formulateFreshPlaybackURL(playerManagerActor: playerManagerActor)
//        if self.formulatedURL != nil {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func primeExistingQueueItemPlayer(position: Double? = nil) async -> Bool {
//        if let position = position {
//            if let queueItemPlayer = self.queueItemPlayer {
//                queueItemPlayer.seek(to: position)
//            }
//        }
//        if (self.primeStatus == .waiting) {
//            return true
//        }
//        return false
//    }
//    
//    func primeObjectForSwitch(playerManagerActor: PlayerManagerActor, continueCurrent: Bool = false, position: Double? = nil) async -> PrimeStatus {
//        guard !self.currentlyPriming else { return .waiting }
//
//        if (self.primeStatus == .failed || self.primeStatus == .success || self.primeStatus == .passed) {
//            return .loading
//        }
//        
//        await self.clearIfDownloaded(playerManagerActor: playerManagerActor)
//        
//        self.currentlyPriming = true
//        
//        if self.queueItemPlayer == nil {
//            let primeSucceeded = await primeFreshQueueItemPlayer(playerManagerActor: playerManagerActor)
//            if primeSucceeded {
//                return .success
//            } else {
//                return .failed
//            }
//        } else {
//            let primeSucceeded = await primeExistingQueueItemPlayer(position: position)
//            if primeSucceeded {
//                return .success
//            } else {
//                return .failed
//            }
//        }
//        
//        //END
//        
//        
//        
//    }
//}
//
//
//// get requests
//extension QueueItemActor {
//    func getFetchedPlayback() -> FetchedPlayback? {
//        return self.fetchedPlayback
//    }
//    
//    func getQueueItemPlayer() -> (any PlayerEngineProtocol)? {
//        return self.queueItemPlayer
//    }
//    
//    func getCurrentTimestamp() -> Double? {
//        return self.queueItemPlayer?.currentTime
//    }
//}
//
//// set requests
//extension QueueItemActor {
//    func setExplicity(to: Bool) {
//        self.explicit = to
//    }
//    
//    func setVideo(to: Bool) {
//        if (self.isVideo != to) {
//            //self.queueItemPlayer?.pause()
//        }
//        if to == true && self.fetchedPlayback?.YT_Video_ID != nil {
//            self.isVideo = true
//            self.video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
//            //self.queueItemPlayer = self.video_AVPlayer
//        } else if (to == false) {
//            self.isVideo = false
//            self.queueItemPlayer = self.audio_AVPlayer
//        }
//    }
//    
//    func setCurrentlyPriming(to: Bool) {
//        self.currentlyPriming = to
//    }
//}
