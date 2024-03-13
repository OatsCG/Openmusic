//
//  PMTransportControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import AVFoundation
import SwiftUI
import MediaPlayer

extension PlayerManager {
    func syncPlayingTimeControls() {
        // push elapsed time to Media Center
        if (self.isUpdatingInfoCenter) {
            return
        }
        DispatchQueue.main.async {
            self.isUpdatingInfoCenter = true
        }
        Task.detached {
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
            DispatchQueue.main.async {
                self.isUpdatingInfoCenter = false
            }
        }
    }
    
    func setupNowPlaying() {
        // push track data to Media Center
        if (self.currentlyTryingInfoCenterAlbumArtUpdate == false && self.currentQueueItem != nil) {
            self.currentlyTryingInfoCenterAlbumArtUpdate = true
            Task.detached {
                do {
                    self.nowPlayingInfo?[MPMediaItemPropertyTitle] = self.currentQueueItem?.Track.Title
                    self.nowPlayingInfo?[MPMediaItemPropertyArtist] = stringArtists(artistlist: self.currentQueueItem?.Track.Album.Artists ?? [])
                    let url: URL? = BuildArtworkURL(imgID: self.currentQueueItem?.Track.Album.Artwork, resolution: .hd)
                    if url == nil {return}
                    let (data, _) = try await URLSession.shared.data(from: url!)
                    if let image = UIImage(data: data) {
                        self.nowPlayingInfo?[MPMediaItemPropertyArtwork] =
                        MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                        }
                    }
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
                    //print("wrote to MPNowPlayingInfoCenter: \(MPNowPlayingInfoCenter.default().nowPlayingInfo!)")
                    //await syncPlayingTimeControls()
                    DispatchQueue.main.async {
                        self.currentlyTryingInfoCenterAlbumArtUpdate = false
                    }
                } catch {
                    print("error pushing to Media Center")
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
            self.pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                self.play()
            } else {
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
            self.player_forward()
            return .success
        }
        self.commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.player_backward()
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
                syncPlayingTimeControls()
                return .success
            }
            return .commandFailed
        }
    }
}
