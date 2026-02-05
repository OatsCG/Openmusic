//
//  QueueItemPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-12.
//

import Foundation

extension QueueItem {
//    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
//        if currentlyPriming {
//            return
//        }
//        if primeStatus == .failed || primeStatus == .success || primeStatus == .passed {
//            DispatchQueue.main.async { [playerManager] in
//                playerManager.prime_next_song()
//            }
//            return
//        }
//        
//        if await DownloadManager.shared.is_downloaded(self, explicit: explicit) {
//            if audio_AVPlayer?.isRemote == true {
//                if queueID != playerManager.currentQueueItem?.queueID {
//                    clearPlayback()
//                }
//            }
//        }
//        currentlyPriming = true
//        if queueItemPlayer == nil {
//            update_prime_status(.loading)
//            DispatchQueue.main.async {
//                let isExplicit: Bool = self.explicit
//                let playback_explicit: String? = self.Track.Playback_Explicit
//                let playback_clean: String? = self.Track.Playback_Clean
//                Task.detached {
//                    let isDownloaded: Bool = await DownloadManager.shared.is_downloaded(self, explicit: isExplicit)
//                    var playbackData: FetchedPlayback? = nil
//                    if !isDownloaded {
//                        if isExplicit, let playback_explicit {
//                            playbackData = try? await fetchPlaybackData(playbackID: playback_explicit)
//                        } else if let playback_clean {
//                            playbackData = try? await fetchPlaybackData(playbackID: playback_clean)
//                        }
//                    }
//                    //getting audio url
//                    DispatchQueue.main.async {
//                        var url: URL? = nil
//                        var isRemote: Bool = true
//                        if !self.isVideo {
//                            if isDownloaded {
//                                if isExplicit, let playback_explicit {
//                                    url = DownloadManager.shared.get_stored_location(PlaybackID: playback_explicit)
//                                } else if let playback_clean {
//                                    url = DownloadManager.shared.get_stored_location(PlaybackID: playback_clean)
//                                }
//                                isRemote = false
//                            } else {
//                                self.fetchedPlayback = playbackData
//                                url = URL(string: self.fetchedPlayback?.Playback_Audio_URL ?? "")
//                            }
//                        }
//                        if url != nil {
//                            DispatchQueue.main.async { [weak self, url, isRemote] in
//                                self?.update_prime_status(.success)
//                                DispatchQueue.main.async { [playerManager] in
//                                    playerManager.prime_next_song()
//                                }
//                                self?.audio_AVPlayer = PlayerEngine(url: url, remote: isRemote)
//                                self?.video_AVPlayer = VideoPlayerEngine(ytid: self?.fetchedPlayback?.YT_Video_ID)
//                                if self?.isVideo == true {
//                                    //self.queueItemPlayer = self.video_AVPlayer
//                                } else {
//                                    self?.queueItemPlayer = self?.audio_AVPlayer
//                                }
//                                self?.queueItemPlayer?.set_volume(to: playerManager.appVolume)
//                                self?.queueItemPlayer?.seek(to: 0)
//                                if let qitem = self {
//                                    playerManager.set_currentlyPlaying(queueItem: qitem)
//                                    Task.detached { [weak self, weak qitem] in
//                                        await self?.queueItemPlayer?.preroll() { success in
//                                            if success {
//                                                DispatchQueue.main.async { [weak self, weak qitem] in
//                                                    if let qitem = qitem {
//                                                        self?.update_prime_status(.primed)
//                                                        DispatchQueue.main.async { [playerManager] in
//                                                            playerManager.prime_next_song()
//                                                        }
//                                                        playerManager.set_currentlyPlaying(queueItem: qitem)
//                                                        if let position {
//                                                            self?.queueItemPlayer?.seek(to: position)
//                                                            if (playerManager.isPlaying) {
//                                                                self?.queueItemPlayer?.play()
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            } else {
//                                                print("PREROLL FAILED")
//                                                Task {
//                                                    await self?.update_prime_status(.failed)
//                                                    DispatchQueue.main.async { [playerManager] in
//                                                        playerManager.prime_next_song()
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        } else {
//                            self.update_prime_status(.failed)
//                            DispatchQueue.main.async { [playerManager] in
//                                playerManager.prime_next_song()
//                            }
//                        }
//                        if playerManager.currentQueueItem?.queueID != self.queueID {
//                            self.audio_AVPlayer?.pause()
//                        }
//                        self.currentlyPriming = false
//                    }
//                }
//            }
//        } else {
//            if primeStatus == .waiting {
//                update_prime_status(.success)
//            }
//            if let position {
//                queueItemPlayer?.seek(to: position)
//                playerManager.addSuggestions()
//            }
//            queueItemPlayer?.preroll() { success in
//                if success {
//                    DispatchQueue.main.async {
//                        if let position {
//                            self.queueItemPlayer?.seek(to: position)
//                        }
//                        playerManager.set_currentlyPlaying(queueItem: self)
//                    }
//                }
//            }
//            currentlyPriming = false
//        }
//        DispatchQueue.main.async { [playerManager] in
//            playerManager.prime_next_song()
//        }
//        return
//    }
    
    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
        await queueItemActor.prime_object(queueItem: self, playerManager: playerManager, continueCurrent: continueCurrent, position: position)
    }
    
    func set_currentlyPriming(_ to: Bool) {
        currentlyPriming = to
    }
    
    func requestCurrentlyPriming() -> Bool {
        if currentlyPriming {
            return false
        } else {
            currentlyPriming = true
            return true
        }
    }
    
    func pause_if_not_current(playerManager: PlayerManager) {
        // regardless of priming, prevent item from playing if it's not the current item.
        if playerManager.currentQueueItem?.queueID != queueID {
            print("PRIMING \(self.Track.Title): not current song; pausing.")
            audio_AVPlayer?.pause()
        }
    }
    
    func set_audio_AVPlayer(_ to: PlayerEngine?) {
        audio_AVPlayer = to
    }
    
    func set_video_AVPlayer(_ to: VideoPlayerEngine?) {
        video_AVPlayer = to
    }
    
    func set_queueItemPlayer(_ to: (any PlayerEngineProtocol)?) {
        queueItemPlayer = to
    }
    
    func set_fetchedPlayback(_ to: FetchedPlayback?) {
        fetchedPlayback = to
    }
    
    func check_duration_error(playerManager: PlayerManager) -> Bool {
        if let queueItemPlayer, queueItemPlayer.isReady {
            if !queueItemPlayer.duration().isNaN, queueItemPlayer.duration() > 0 {
                return false
            } else {
                self.prime_object_fresh(playerManager: playerManager, continueCurrent: false, seek: false)
                return true
            }
        }
        return false
    }
    
    func preroll_queueItemPlayer(playerManager: PlayerManager, position: Double? = nil) {
        queueItemPlayer?.preroll() { success in
            print("PRIMING \(self.Track.Title): prerolling.")
            if success {
                self.update_prime_status(.primed)
                playerManager.prime_next_song()
                if let position {
                    self.queueItemPlayer?.seek(to: position)
                    playerManager.addSuggestions()
                }
                playerManager.set_currentlyPlaying(queueItem: self)
                // check duration
                print("PRIMING \(self.Track.Title): checking duration: \(self.queueItemPlayer?.duration())")
//                if let duration = self.queueItemPlayer?.duration(), duration.isNaN {
//                    print("PRIMING \(self.Track.Title): duration is .nan, re-preroll. rerolling.")
//                    defer {
//                        self.prime_object_fresh(playerManager: playerManager)
//                    }
//                    return
//                }
                if playerManager.isPlaying && playerManager.currentQueueItem?.queueID == self.queueID {
                    self.queueItemPlayer?.play()
                } else {
                    self.queueItemPlayer?.pause()
                }
            } else {
                self.update_prime_status(.failed)
                playerManager.prime_next_song()
            }
        }
    }
}
