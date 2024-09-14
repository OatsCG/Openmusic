//
//  QueueItemPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-12.
//

import Foundation

extension QueueItem {
    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
        if (self.currentlyPriming) {
            return
        }
        if (self.primeStatus == .failed || self.primeStatus == .success || self.primeStatus == .passed) {
            DispatchQueue.main.async { [playerManager] in
                playerManager.prime_next_song()
            }
            return
        }
        
        if await DownloadManager.shared.is_downloaded(self, explicit: self.explicit) {
            if self.audio_AVPlayer?.isRemote == true {
                if self.queueID != playerManager.currentQueueItem?.queueID {
                    self.clearPlayback()
                }
            }
        }
        self.currentlyPriming = true
        if self.queueItemPlayer == nil {
            self.update_prime_status(.loading)
            DispatchQueue.main.async {
                let isExplicit: Bool = self.explicit
                let playback_explicit: String? = self.Track.Playback_Explicit
                let playback_clean: String? = self.Track.Playback_Clean
                Task.detached {
                    var isDownloaded: Bool = await DownloadManager.shared.is_downloaded(self, explicit: isExplicit)
                    var playbackData: FetchedPlayback? = nil
                    if (!isDownloaded) {
                        playbackData = try? await fetchPlaybackData(playbackID: isExplicit ? playback_explicit! : playback_clean!)
                    }
                    //getting audio url
                    DispatchQueue.main.async {
                        var url: URL? = nil
                        var isRemote: Bool = true
                        if (self.isVideo == false) {
                            if isDownloaded {
                                url = DownloadManager.shared.get_stored_location(PlaybackID: isExplicit ? playback_explicit! : playback_clean!)
                                isRemote = false
                            } else {
                                self.fetchedPlayback = playbackData
                                url = URL(string: self.fetchedPlayback?.Playback_Audio_URL ?? "")
                            }
                        }
                        if url != nil {
                            DispatchQueue.main.async { [weak self, url, isRemote] in
                                self?.update_prime_status(.success)
                                DispatchQueue.main.async { [playerManager] in
                                    playerManager.prime_next_song()
                                }
                                self?.audio_AVPlayer = PlayerEngine(url: url, remote: isRemote)
                                self?.video_AVPlayer = VideoPlayerEngine(ytid: self?.fetchedPlayback?.YT_Video_ID)
                                if (self?.isVideo == true) {
                                    //self.queueItemPlayer = self.video_AVPlayer
                                } else {
                                    self?.queueItemPlayer = self?.audio_AVPlayer
                                }
                                self?.queueItemPlayer?.set_volume(to: playerManager.appVolume)
                                self?.queueItemPlayer?.seek(to: 0)
                                if let qitem = self {
                                    playerManager.set_currentlyPlaying(queueItem: qitem)
                                    Task.detached { [weak self, weak qitem] in
                                        await self?.queueItemPlayer?.preroll() { success in
                                            if success {
                                                DispatchQueue.main.async { [weak self, weak qitem] in
                                                    if let qitem = qitem {
                                                        self?.update_prime_status(.primed)
                                                        DispatchQueue.main.async { [playerManager] in
                                                            playerManager.prime_next_song()
                                                        }
                                                        playerManager.set_currentlyPlaying(queueItem: qitem)
                                                        if position != nil {
                                                            self?.queueItemPlayer!.seek(to: position!)
                                                            if (playerManager.isPlaying) {
                                                                self?.queueItemPlayer?.play()
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                print("PREROLL FAILED")
                                                Task {
                                                    await self?.update_prime_status(.failed)
                                                    DispatchQueue.main.async { [playerManager] in
                                                        playerManager.prime_next_song()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            self.update_prime_status(.failed)
                            DispatchQueue.main.async { [playerManager] in
                                playerManager.prime_next_song()
                            }
                        }
                        if (playerManager.currentQueueItem?.queueID != self.queueID) {
                            self.audio_AVPlayer?.pause()
                        }
                        self.currentlyPriming = false
                    }
                }
            }
        } else {
            if (self.primeStatus == .waiting) {
                self.update_prime_status(.success)
            }
            if position != nil {
                self.queueItemPlayer!.seek(to: position!)
                playerManager.addSuggestions()
            }
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
        DispatchQueue.main.async { [playerManager] in
            playerManager.prime_next_song()
        }
        return
    }
}
