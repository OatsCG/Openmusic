//
//  playerqueuehandler.swift
//  openmusic
//
//  Created by Charlie Giannis on 2022-09-18.
//

@preconcurrency import AVFoundation
import SwiftUI
@preconcurrency import MediaPlayer
import Combine


@MainActor
@Observable class PlayerManager {    
    // audio engine
    let audioEngine = AVAudioEngine() // not even used i think????
    
    //player
    var isPlaying: Bool
    var elapsedTime: Double
    var durationSeconds: Double
    var elapsedNormal: Double
    var appVolume: Float // keep actor updated
    
    //crossfade
    var crossfadeSeconds: Double
    var crossfadeAlbums: Bool
    
    // queue
    var currentQueueItem: QueueItem?
    var trackQueue: [QueueItem]
    var sessionHistory: [QueueItem]
    var repeatMode: RepeatMode = .off
    
    // suggestions
    var fetchSuggestionsModel: FetchSuggestionsModel = FetchSuggestionsModel()
    var shouldSuggestPlaylistCreation: Bool = false
    var hasSuggestedPlaylistCreation: Bool = false
    
    // controls
    var volumeSkipEnabled: Bool
    var volumeSkipSpeed: Double
    var volumeSkipMargin: Double
    var SkipNotifyEnabled: Bool = false
    var lastVolume: (Float, Float, Double, Bool)? = nil // (old, new, time, valid start)
    
    // actor
    var PMActor: PlayerManagerActor

    
    init(dormant: Bool) {
        self.isPlaying = false
        self.currentQueueItem = nil
        self.trackQueue = []
        self.sessionHistory = []
        self.elapsedTime = 0
        self.durationSeconds = 0.9
        self.elapsedNormal = 0
        self.appVolume = 1
        self.crossfadeSeconds = 0
        self.crossfadeAlbums = false
        self.volumeSkipEnabled = false
        self.volumeSkipSpeed = 0
        self.volumeSkipMargin = 0
        self.PMActor = PlayerManagerActor()
        if self.volumeSkipSpeed == 0 {
            self.volumeSkipSpeed = 0.5
        }
        if self.volumeSkipMargin == 0 {
            self.volumeSkipMargin = 0.7
        }
    }
    
    init() {
        self.isPlaying = false
        self.currentQueueItem = nil
        self.trackQueue = []
        self.sessionHistory = []
        self.elapsedTime = 0
        self.durationSeconds = 0.9
        self.elapsedNormal = 0
        self.appVolume = 1
        self.crossfadeSeconds = UserDefaults.standard.double(forKey: "crossfadeSeconds") == 0 ? 0.15 : UserDefaults.standard.double(forKey: "crossfadeSeconds")
        self.crossfadeAlbums = UserDefaults.standard.bool(forKey: "crossfadeAlbums")
        self.volumeSkipEnabled = UserDefaults.standard.bool(forKey: "volumeSkipEnabled")
        self.volumeSkipSpeed = UserDefaults.standard.double(forKey: "volumeSkipSpeed")
        self.volumeSkipMargin = UserDefaults.standard.double(forKey: "volumeSkipMargin")
        self.PMActor = PlayerManagerActor()
        if self.volumeSkipSpeed == 0 {
            self.volumeSkipSpeed = 0.5
        }
        if self.volumeSkipMargin == 0 {
            self.volumeSkipMargin = 0.7
        }

        //initialize volume observer
        VolumeObserver.shared.VolumeSkipObserver = { newValue in
            self.volume_control_check(oldValue: VolumeObserver.shared.oldValue, newValue: VolumeObserver.shared.newValue)
        }
        //update timer
        self.update_timer(to: 0.1)
    }
    
    func updateUI(userInitiated: Bool = true) async {
        print("update ui: START")
        await self.PMActor.setAppVolume(to: self.appVolume)
        // player
        let isPlaying = await self.PMActor.isPlaying
        let elapsedTime = await self.PMActor.elapsedTime
        let durationSeconds = await self.PMActor.durationSeconds
        let elapsedNormal = await self.PMActor.elapsedNormal
        let currentQueueItem = await self.PMActor.currentQueueItem
        let trackQueue = await self.PMActor.trackQueue
        let sessionHistory = await self.PMActor.sessionHistory
        withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
            self.isPlaying = isPlaying
            self.elapsedTime = elapsedTime
            self.durationSeconds = durationSeconds
            self.elapsedNormal = elapsedNormal
            self.currentQueueItem = currentQueueItem
            self.trackQueue = trackQueue
            self.sessionHistory = sessionHistory
        }
        print("update ui: DONE")
    }
    
    func update_timer(to: Double) {
        Task {
            await self.PMActor.update_timer(to: to)
            await self.updateUI()
        }
    }
    
    func track_reached_end() {
        // DONE
        self.player_forward()
    }
    
    func is_playing() -> Bool {
        return self.isPlaying
    }
    
    func end_song_check() {
        if (self.durationSeconds - self.elapsedTime < 0.01) {
            self.player_forward()
        }
    }
    
    func setRepeatMode(to: RepeatMode) {
        self.repeatMode = to
        Task {
            await self.PMActor.setRepeatMode(to: to)
            await self.updateUI()
        }
    }
    
    func updateUI(userInitiated: Bool) {
        withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
            //TODO: update values from PMActor
        }
    }
}
