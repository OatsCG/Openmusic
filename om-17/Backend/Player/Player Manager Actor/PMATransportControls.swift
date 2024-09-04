//
//  PMATransportControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI
import MediaPlayer

extension PlayerManagerActor {
    func setupNowPlaying() async {
        // push track data to Media Center
        if (self.currentlyTryingInfoCenterAlbumArtUpdate == false && self.currentQueueItem != nil) {
            self.currentlyTryingInfoCenterAlbumArtUpdate = true
            await self.nowPlayingInfo?[MPMediaItemPropertyTitle] = self.currentQueueItem?.Track.Title
            await self.nowPlayingInfo?[MPMediaItemPropertyArtist] = stringArtists(artistlist: self.currentQueueItem?.Track.Album.Artists ?? [])
            self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = nil
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            
            var artworkURL: URL? = nil
            if await ArtworkExists(ArtworkID: self.currentQueueItem?.Track.Album.Artwork) {
                if let artwork = await self.currentQueueItem?.Track.Album.Artwork {
                    artworkURL = RetrieveArtwork(ArtworkID: artwork)
                }
            } else {
                await artworkURL = BuildArtworkURL(imgID: self.currentQueueItem?.Track.Album.Artwork, resolution: .hd)
            }
            if let artworkURL = artworkURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: artworkURL)
                    if let image = UIImage(data: data) {
                        self.nowPlayingInfo?[MPMediaItemPropertyArtwork] =
                        MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                        }
                    }
                } catch {
                    print("error pushing to Media Center")
                }
            }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            
            self.currentlyTryingInfoCenterAlbumArtUpdate = false
        }
        self.defineInterruptionObserver()
    }
    
    func defineInterruptionObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance(),
                       queue: .main) { [weak self] notification in
            Task {
                await self?.handleInterruption(notification: notification)
            }
        }
    }

    func handleInterruption(notification: Notification) async {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            print("[pause] began interruption")
            await self.pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            self.setupRemoteTransportControls()
            self.setAudioSession()
            if options.contains(.shouldResume) {
                print("[pause] ended interruption, playing")
                await self.play()
            } else {
                print("[pause] ended interruption")
                await self.pause()
            }
        default: ()
        }
    }

    
    func setupRemoteTransportControls() {
        // sets up system play/pause commands
        if self.commandCenterAlreadyLoaded {
            return
        }
        self.commandCenterAlreadyLoaded = true
        self.commandCenter.changePlaybackPositionCommand.isEnabled = true
        
        self.commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            Task {
                await self.playerForward(userInitiated: true)
            }
            return .success
        }
        self.commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            Task {
                await self.playerBackward(userInitiated: true)
            }
            return .success
        }
        self.commandCenter.playCommand.addTarget { [unowned self] event in
            Task {
                await self.play()
            }
            return .success
        }
        self.commandCenter.pauseCommand.addTarget { [unowned self] event in
            Task {
                await self.pause()
            }
            return .success
        }
        self.commandCenter.stopCommand.addTarget { [unowned self] event in
            Task {
                await self.pause()
            }
            return .success
        }
        self.commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                Task {
                    self.player.seek(to: event.positionTime)
                    await self.play()
                    await self.syncPlayingTimeControls()
                }
                return .success
            }
            return .commandFailed
        }
    }

    
    func syncPlayingTimeControls() async {
        // push elapsed time to Media Center
        if (self.isUpdatingInfoCenter) {
            return
        }
        self.isUpdatingInfoCenter = true
        if await (self.currentQueueItem?.isReady ?? false && self.durationSeconds > 1) {
            self.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.elapsedTime
            self.nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = self.durationSeconds
            self.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = self.isPlaying ? 1.0 : 0.0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
        } else {
            self.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = nil
            self.nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = nil
            self.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
        }
        self.isUpdatingInfoCenter = false
    }
}
