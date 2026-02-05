//
//  QueueItemActor.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-30.
//

import SwiftUI

actor QueueItemActor {
    func prime_object(queueItem: QueueItem, playerManager: PlayerManager, continueCurrent: Bool = false, position: Double? = nil) async {
        // guards
        print("PRIMING \(await queueItem.Track.Title): guarding")
        guard await queueItem.requestCurrentlyPriming() else { return }
        
        guard await queueItem.primeStatus != .success, await queueItem.primeStatus != .passed, await queueItem.primeStatus != .failed else {
            print("PRIMING \(await queueItem.Track.Title): done in past, priming next song")
            await playerManager.prime_next_song()
            return
        }
        
        // if a local file exists, clear all past priming.
        // WHAT THIS SOLVES: if this song is queued, then downloaded. It should play the downloaded version.
        if await DownloadManager.shared.is_downloaded(queueItem, explicit: queueItem.explicit), await queueItem.audio_AVPlayer?.isRemote == true {
            print("PRIMING \(await queueItem.Track.Title): downloaded recently, clearing existing playback")
            if await queueItem.queueID != playerManager.currentQueueItem?.queueID {
                await queueItem.clearPlayback()
            }
        }
        
        // start priming
        print("PRIMING \(await queueItem.Track.Title): start priming")
        
        if let queueItemPlayer = await queueItem.queueItemPlayer {
            // if audio is already loaded, prepare for playback.
            print("PRIMING \(await queueItem.Track.Title): audio engine already loaded, prepping for playback")
            await queueItem.update_prime_status(.success)
            await queueItem.preroll_queueItemPlayer(playerManager: playerManager, position: position)
        } else { // if an audio is not loaded, load and prepare for playback.
            await queueItem.update_prime_status(.loading)
            // fetch audio URL; either local file or remote URL.
            print("PRIMING \(await queueItem.Track.Title): audio not loaded. starting file search")
            var url: URL? = nil
            var isRemote: Bool = true
            if await !queueItem.isVideo {
                // if downloaded file exists, set its location as the url.
                if await DownloadManager.shared.is_downloaded(queueItem, explicit: queueItem.explicit) {
                    print("PRIMING \(await queueItem.Track.Title): was downloaded, using that location")
                    if await queueItem.explicit, let playback_explicit = await queueItem.Track.Playback_Explicit {
                        print("PRIMING \(await queueItem.Track.Title): using explicit downloaded")
                        url = await DownloadManager.shared.get_stored_location(PlaybackID: playback_explicit)
                    } else if let playback_clean = await queueItem.Track.Playback_Clean {
                        print("PRIMING \(await queueItem.Track.Title): using clean downloaded")
                        url = await DownloadManager.shared.get_stored_location(PlaybackID: playback_clean)
                    }
                    isRemote = false
                } else { // if not downloaded, fetch the remote playback url.
                    print("PRIMING \(await queueItem.Track.Title): not downloaded, using remote")
                    if await queueItem.explicit, let playback_explicit = await queueItem.Track.Playback_Explicit {
                        print("PRIMING \(await queueItem.Track.Title): trying explicit remote: \(playback_explicit)")
                        try? await queueItem.set_fetchedPlayback(fetchPlaybackData(playbackID: playback_explicit))
                    } else if let playback_clean = await queueItem.Track.Playback_Clean {
                        print("PRIMING \(await queueItem.Track.Title): trying clean remote: \(playback_clean)")
                        try? await queueItem.set_fetchedPlayback(fetchPlaybackData(playbackID: playback_clean))
                    }
                    print("PRIMING \(await queueItem.Track.Title): Playback_Audio_URL: \(await queueItem.fetchedPlayback?.Playback_Audio_URL)")
                    url = await URL(string: queueItem.fetchedPlayback?.Playback_Audio_URL ?? "")
                }
            }
            
            if let url {
                // if a url exists, start priming it.
                print("PRIMING \(await queueItem.Track.Title): url exists, starting engine.")
                await queueItem.update_prime_status(.success)
                await playerManager.prime_next_song()
                
                // create engine
                await queueItem.set_audio_AVPlayer(PlayerEngine(url: url, remote: isRemote))
                
                await queueItem.set_video_AVPlayer(VideoPlayerEngine(ytid: queueItem.fetchedPlayback?.YT_Video_ID))
                
                // assign audio engine as this item's current engine
                if await !queueItem.isVideo {
                    await queueItem.set_queueItemPlayer(queueItem.audio_AVPlayer)
                }
                
                await queueItem.queueItemPlayer?.set_volume(to: playerManager.appVolume)
                await queueItem.queueItemPlayer?.seek(to: 0)
                await playerManager.set_currentlyPlaying(queueItem: queueItem)
                
                await queueItem.preroll_queueItemPlayer(playerManager: playerManager, position: position)
            } else {
                // if no url was fetched, an error occurred.
                print("PRIMING \(await queueItem.Track.Title): no url.")
                await queueItem.update_prime_status(.failed)
                await playerManager.prime_next_song()
            }
        }
        
        // regardless of priming, prevent item from playing if it's not the current item.
        await queueItem.pause_if_not_current(playerManager: playerManager)
        // done.
        await queueItem.set_currentlyPriming(false)
        await playerManager.prime_next_song()
    }
}
