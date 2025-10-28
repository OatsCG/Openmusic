//
//  playerqueuehandler.swift
//  openmusic
//
//  Created by Charlie Giannis on 2022-09-18.
//

import AVFoundation
import SwiftUI
import MediaPlayer
import Combine

@Observable class PlayerManager: Sendable {
    let commandCenter = MPRemoteCommandCenter.shared()
    let audioSession = AVAudioSession.sharedInstance()
    
    // audio engine
    var audioEngine = AVAudioEngine()
    
    //player
    var player: any PlayerEngineProtocol
    var isPlaying: Bool
    var elapsedTime: Double
    var durationSeconds: Double
    var elapsedNormal: Double
    var appVolume: Float
    
    //player fade
    var play_fade_timer: Timer? = nil
    var pause_fade_timer: Timer? = nil
    var current_fade_step: Int = 0
    var total_fade_steps: Int = 100
    var startingVol: Float = 1.0
    
    //crossfade
    var crossfadeZero: Double
    var crossfadeZeroDownload: Double
    var crossfadeSeconds: Double
    var isCrossfading: Bool
    var crossfadeTimer: Timer
    var crossfadeAlbums: Bool
    
    // queue
    var currentQueueItem: QueueItem?
    var trackQueue: [QueueItem]
    var sessionHistory: [QueueItem]
    var repeatMode: RepeatMode = .off
    var didAddFromRepeat: Bool = false
    
    // suggestions
    var fetchSuggestionsModel: FetchSuggestionsModel = FetchSuggestionsModel()
    var shouldSuggestPlaylistCreation: Bool = false
    var hasSuggestedPlaylistCreation: Bool = false
    
    // vibes
    var currentVibe: VibeObject? = nil
    
    // controls
    var lastVolume: (Float, Float, Double, Bool)? = nil // (old, new, time, valid start)
    var volumeSkipEnabled: Bool
    var volumeSkipSpeed: Double
    var volumeSkipMargin: Double
    var lastWaveDepth: (Bool, Double, Bool) = (false, 0, false) // (last, time, valid)
    var SkipNotifyEnabled: Bool = false
    var notificationManager = NotificationManager()
    var volumeObserver = VolumeObserver()
    
    // transport
    var commandCenterAlreadyLoaded: Bool
    var currentlyTryingInfoCenterAlbumArtUpdate: Bool
    var nowPlayingInfo:[String : Any]? = [:]
    var isUpdatingInfoCenter: Bool = false
    
    // synced timer
    var syncedTimerInterval: Double = 1
    var syncedTimer: Timer? = nil
    var timerMidFire: Bool = false

    
    init(dormant: Bool) {
        commandCenterAlreadyLoaded = false
        currentlyTryingInfoCenterAlbumArtUpdate = false
        player = PlayerEngine()
        isPlaying = false
        currentQueueItem = nil
        trackQueue = []
        sessionHistory = []
        elapsedTime = 0
        durationSeconds = 0.9
        elapsedNormal = 0
        appVolume = 1
        crossfadeZero = 0.15
        crossfadeZeroDownload = 0.05
        crossfadeSeconds = 0
        isCrossfading = false
        didAddFromRepeat = false
        crossfadeTimer = Timer()
        crossfadeAlbums = false
        volumeSkipEnabled = false
        volumeSkipSpeed = 0
        volumeSkipMargin = 0
        if volumeSkipSpeed == 0 {
            volumeSkipSpeed = 0.5
        }
        if volumeSkipMargin == 0 {
            volumeSkipMargin = 0.7
        }
        Task {
            await volumeObserver.initSliders()
        }
    }
    
    init() {
        commandCenterAlreadyLoaded = false
        currentlyTryingInfoCenterAlbumArtUpdate = false
        player = PlayerEngine()
        isPlaying = false
        currentQueueItem = nil
        trackQueue = []
        sessionHistory = []
        elapsedTime = 0
        durationSeconds = 0.9
        elapsedNormal = 0
        appVolume = 1
        crossfadeZero = 0.15
        crossfadeZeroDownload = 0.05
        crossfadeSeconds = UserDefaults.standard.double(forKey: "crossfadeSeconds") == 0 ? 0.15 : UserDefaults.standard.double(forKey: "crossfadeSeconds")
        isCrossfading = false
        didAddFromRepeat = false
        crossfadeTimer = Timer()
        crossfadeAlbums = UserDefaults.standard.bool(forKey: "crossfadeAlbums")
        volumeSkipEnabled = UserDefaults.standard.bool(forKey: "volumeSkipEnabled")
        volumeSkipSpeed = UserDefaults.standard.double(forKey: "volumeSkipSpeed")
        volumeSkipMargin = UserDefaults.standard.double(forKey: "volumeSkipMargin")
        if volumeSkipSpeed == 0 {
            volumeSkipSpeed = 0.5
        }
        if volumeSkipMargin == 0 {
            volumeSkipMargin = 0.7
        }
        
        //initialize media center
        setupRemoteTransportControls()
        //setAudioSession()

        //initialize volume observer
        volumeObserver.VolumeSkipObserver = { newValue in
            Task {
                await self.volume_control_check(oldValue: self.volumeObserver.oldValue, newValue: self.volumeObserver.newValue)
            }
        }
        //update timer
        update_timer(to: 0.1)
        
        // start volume observer
        Task {
            await volumeObserver.initSliders()
        }
    }
    
    func update_timer(to: Double) {
        if syncedTimerInterval == to {
            return
        }
        DispatchQueue.main.async {
            self.syncedTimerInterval = to
            self.syncedTimer?.invalidate()
            self.syncedTimer = Timer.scheduledTimer(withTimeInterval: to, repeats: true) { _ in
                Task {
                    await self.timer_fired()
                }
            }
            self.syncedTimer?.fire()
        }
    }
    
    func timer_fired() async {
        if !timerMidFire {
            timerMidFire = true
            syncPlayingTimeControls()
            update_elapsed_time()
            await repeat_check()
            await crossfade_check()
            await try_auto_skip_if_necessary()
            timerMidFire = false
        }
    }
    
    func track_reached_end() async {
        await player_forward()
    }
    
    func is_playing() -> Bool {
        isPlaying
    }
    
    func end_song_check() async{
        if durationSeconds - elapsedTime < 0.01 {
            await player_forward()
        }
    }
}
