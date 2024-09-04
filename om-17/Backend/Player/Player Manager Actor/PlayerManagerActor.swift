//
//  PlayerManagerActor.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI
import AVFoundation
import MediaPlayer

actor PlayerManagerActor {
    let audioSession = AVAudioSession.sharedInstance()
    
    let commandCenter = MPRemoteCommandCenter.shared() // actorize (not used anywhere outside of PlayerManager+extensions)
    
    // player
    var isPlaying: Bool = false // UPDATE
    var player: any PlayerEngineProtocol
    var elapsedTime: Double // UPDATE
    var durationSeconds: Double // UPDATE
    var elapsedNormal: Double // UPDATE
    var appVolume: Float
    
    // player fade
    var total_fade_steps: Int = 100
    var startingVol: Float = 1.0
    
    //crossfade
    var crossfadeSeconds: Double
    var crossfadeZero: Double
    var crossfadeZeroDownload: Double
    var isCrossfading: Bool
    var crossfadeTimer: Timer
    
    // queue
    var currentQueueItem: QueueItem? = nil // UPDATE
    var trackQueue: [QueueItem] = [] // UPDATE
    var sessionHistory: [QueueItem] = [] // UPDATE
    var didAddFromRepeat: Bool = false
    
    // suggestions
    var shouldSuggestPlaylistCreation: Bool = false
    var hasSuggestedPlaylistCreation: Bool = false
    
    // controls
    var lastVolume: (Float, Float, Double, Bool)? = nil // (old, new, time, valid start)
    var lastWaveDepth: (Bool, Double, Bool) = (false, 0, false) // (last, time, valid)
    var notificationManager: NotificationManager = NotificationManager()
    
    // transport
    var commandCenterAlreadyLoaded: Bool
    var currentlyTryingInfoCenterAlbumArtUpdate: Bool
    var nowPlayingInfo:[String : Any]? = [:]
    var isUpdatingInfoCenter: Bool = false
    
    // synced timer
    var syncedTimerInterval: Double = 1 // actorize
    var syncedTimer: Timer? = nil // actorize
    var timerMidFire: Bool = false // actorize
    
    
    init () {
        self.player = PlayerEngine()
        
        self.commandCenterAlreadyLoaded = false
        self.currentlyTryingInfoCenterAlbumArtUpdate = false
        
        self.crossfadeZero = 0.15
        self.crossfadeZeroDownload = 0.05
        
        self.isCrossfading = false
        self.didAddFromRepeat = false
        self.crossfadeTimer = Timer()
        
        self.appVolume = 1
        
        //initialize media center
        self.setupRemoteTransportControls()
        
        //setAudioSession()
        //update timer
        self.update_timer(to: 0.1)
    }
    
    func setIsPlaying(to: Bool) {
        if (to == true) {
            try? self.audioSession.setActive(true)
        }
        self.isPlaying = to
    }
    
    func update_timer(to: Double) {
        if (self.syncedTimerInterval == to) {
            return
        }
        self.syncedTimerInterval = to
        self.syncedTimer?.invalidate()
        self.syncedTimer = Timer.scheduledTimer(withTimeInterval: to, repeats: true) { _ in
            Task {
                await self.timer_fired()
            }
        }
        self.syncedTimer?.fire()
    }
    
    func timer_fired() async {
        if self.timerMidFire == false {
            self.timerMidFire = true
            await self.syncPlayingTimeControls()
            //self.update_elapsed_time()
            self.repeat_check()
            self.crossfade_check()
            await self.try_auto_skip_if_necessary()
            self.timerMidFire = false
        }
    }
    
    func setAppVolume(to: Float) {
        self.appVolume = to
    }
}
