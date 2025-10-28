//
//  QueueItemPriming.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-12.
//

import Foundation

extension QueueItem {
    func prime_object(playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
        if currentlyPriming {
            return
        }
        if primeStatus == .failed || primeStatus == .success || primeStatus == .passed {
            await playerManager.prime_next_song()
            return
        }
        
        if await DownloadManager.shared.is_downloaded(self, explicit: explicit) {
            if audio_AVPlayer?.isRemote == true {
                if queueID != playerManager.currentQueueItem?.queueID {
                    clearPlayback()
                }
            }
        }
        currentlyPriming = true
        if queueItemPlayer == nil {
            update_prime_status(.loading)
            let isExplicit: Bool = self.explicit
            let playback_explicit: String? = self.Track.Playback_Explicit
            let playback_clean: String? = self.Track.Playback_Clean
            let isDownloaded: Bool = await DownloadManager.shared.is_downloaded(self, explicit: isExplicit)
            var playbackData: FetchedPlayback? = nil
            if !isDownloaded {
                if isExplicit, let playback_explicit {
                    playbackData = try? await fetchPlaybackData(playbackID: playback_explicit)
                } else if let playback_clean {
                    playbackData = try? await fetchPlaybackData(playbackID: playback_clean)
                }
            }
            //getting audio url
            var url: URL? = nil
            var isRemote: Bool = true
            if !self.isVideo {
                if isDownloaded {
                    if isExplicit, let playback_explicit {
                        url = await DownloadManager.shared.get_stored_location(PlaybackID: playback_explicit)
                    } else if let playback_clean {
                        url = await DownloadManager.shared.get_stored_location(PlaybackID: playback_clean)
                    }
                    isRemote = false
                } else {
                    self.fetchedPlayback = playbackData
                    url = URL(string: self.fetchedPlayback?.Playback_Audio_URL ?? "")
                }
            }
            if url != nil {
                self.update_prime_status(.success)
                await playerManager.prime_next_song()
                self.audio_AVPlayer = PlayerEngine(url: url, remote: isRemote)
                self.video_AVPlayer = VideoPlayerEngine(ytid: self.fetchedPlayback?.YT_Video_ID)
                if self.isVideo == true {
                    //self.queueItemPlayer = self.video_AVPlayer
                } else {
                    self.queueItemPlayer = self.audio_AVPlayer
                }
                self.queueItemPlayer?.set_volume(to: playerManager.appVolume)
                self.queueItemPlayer?.seek(to: 0)
                await playerManager.set_currentlyPlaying(queueItem: self)
                await self.queueItemPlayer?.preroll() { success in
                    if success {
                        self.update_prime_status(.primed)
                        await playerManager.prime_next_song()
                        await playerManager.set_currentlyPlaying(queueItem: self)
                        if let position {
                            self.queueItemPlayer?.seek(to: position)
                            if (playerManager.isPlaying) {
                                self.queueItemPlayer?.play()
                            }
                        }
                    } else {
                        print("PREROLL FAILED")
                        self.update_prime_status(.failed)
                        await playerManager.prime_next_song()
                    }
                }
            } else {
                self.update_prime_status(.failed)
                await playerManager.prime_next_song()
            }
            if playerManager.currentQueueItem?.queueID != self.queueID {
                self.audio_AVPlayer?.pause()
            }
            self.currentlyPriming = false
        } else {
            if primeStatus == .waiting {
                update_prime_status(.success)
            }
            if let position {
                queueItemPlayer?.seek(to: position)
                await playerManager.addSuggestions()
            }
            await queueItemPlayer?.preroll() { success in
                if success {
                    if let position {
                        self.queueItemPlayer?.seek(to: position)
                    }
                    await playerManager.set_currentlyPlaying(queueItem: self)
                }
            }
            currentlyPriming = false
        }
        await playerManager.prime_next_song()
        return
    }
}
