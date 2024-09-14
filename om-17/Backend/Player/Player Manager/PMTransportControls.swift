//
//  PMTransportControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import AVFoundation
import SwiftUI
@preconcurrency import MediaPlayer

extension PlayerManager {
    func syncPlayingTimeControls() {
        // push elapsed time to Media Center
        if (self.isUpdatingInfoCenter) {
            return
        }
        DispatchQueue.main.async { [unowned self] in
            self.isUpdatingInfoCenter = true
            if (self.currentQueueItem?.isReady() ?? false && self.durationSeconds > 1) {
                self.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.elapsedTime
                self.nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = self.durationSeconds
                self.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = self.is_playing() ? 1.0 : 0.0
                MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            } else {
                self.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = nil
                self.nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = nil
                self.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
                MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            }
            self.isUpdatingInfoCenter = false
        }
//        Task.detached {
//
//        }
    }
    
    func setupNowPlaying() {
        // push track data to Media Center
        if (self.currentlyTryingInfoCenterAlbumArtUpdate == false && self.currentQueueItem != nil) {
            self.currentlyTryingInfoCenterAlbumArtUpdate = true
            Task.detached { [unowned self] in
                let title = await self.currentQueueItem?.Track.Title
                let artists = await stringArtists(artistlist: self.currentQueueItem?.Track.Album.Artists ?? [])
                
                await MainActor.run {
                    self.nowPlayingInfo?[MPMediaItemPropertyTitle] = title
                    self.nowPlayingInfo?[MPMediaItemPropertyArtist] = artists
                    self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = nil
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
                }
                
                var artworkURL: URL? = nil
                if await ArtworkExists(ArtworkID: self.currentQueueItem?.Track.Album.Artwork) {
                    if let artwork = await self.currentQueueItem?.Track.Album.Artwork {
                        artworkURL = RetrieveArtwork(ArtworkID: artwork)
                    }
                } else {
                    artworkURL = await BuildArtworkURL(imgID: self.currentQueueItem?.Track.Album.Artwork, resolution: .hd)
                }
                if let artworkURL = artworkURL {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: artworkURL)
                        if let image = UIImage(data: data) {
                            let mpMediaArtwork = MPMediaItemArtwork(boundsSize: image.size) { size in
                                return image
                            }
                            await MainActor.run { [mpMediaArtwork] in
                                self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = mpMediaArtwork
                            }
                        }
                    } catch {
                        print("error pushing to Media Center")
                    }
                }
                
                await MainActor.run {
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
                    self.currentlyTryingInfoCenterAlbumArtUpdate = false
                }
            }
        }
    }
    
    func defineInterruptionObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance())
    }
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        switch type {
        case .began:
            print("[pause] began interruption")
            self.pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            self.setupRemoteTransportControls()
            self.setAudioSession()
            if options.contains(.shouldResume) {
                print("[pause] ended interruption, playing")
                self.play()
            } else {
                print("[pause] ended interruption")
                self.pause()
            }
        default: ()
        }
    }
    
    func setupRemoteTransportControls() {
        // sets up system play/pause commands
        if (self.commandCenterAlreadyLoaded) {
            return
        }
        self.commandCenterAlreadyLoaded = true
        self.commandCenter.changePlaybackPositionCommand.isEnabled = true;
        
        self.commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.player_forward(userInitiated: true)
            return .success
        }
        self.commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.player_backward(userInitiated: true)
            return .success
        }
        self.commandCenter.playCommand.addTarget { [unowned self] event in
//            if self.is_playing() == false {
//                self.play()
//                return .success
//            }
//            return .commandFailed
            self.play()
            return .success
        }
        self.commandCenter.pauseCommand.addTarget { [unowned self] event in
//            if self.is_playing() == true {
//                self.pause()
//                return .success
//            }
//            return .commandFailed
            self.pause()
            return .success
        }
        self.commandCenter.stopCommand.addTarget { [unowned self] event in
            print("\(self.currentQueueItem?.Track.Title ?? "nil") STOPPED")
            self.pause()
            return .success
            
//            if self.player.rate == 1.0 {
//                self.pause()
//                return .success
//            }
//            return .commandFailed
        }
        self.commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                self.player.seek(to: event.positionTime)
                self.play()
                syncPlayingTimeControls()
                return .success
            }
            return .commandFailed
        }
    }
}
