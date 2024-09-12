////
////  PlayerManagerActor.swift
////  om-17
////
////  Created by Charlie Giannis on 2024-08-28.
////
//
//import SwiftUI
//import AVFoundation
//import MediaPlayer
//
//actor PlayerManagerActor {
//    let audioSession = AVAudioSession.sharedInstance()
//    
//    let commandCenter = MPRemoteCommandCenter.shared() // actorize (not used anywhere outside of PlayerManager+extensions)
//    
//    // player
//    var isPlaying: Bool = false // UPDATE
//    var player: any PlayerEngineProtocol
//    var elapsedTime: Double // UPDATE
//    var durationSeconds: Double // UPDATE
//    var elapsedNormal: Double // UPDATE
//    var appVolume: Float
//    
//    // player fade
//    var total_fade_steps: Int = 100
//    var startingVol: Float = 1.0
//    
//    //crossfade
//    var crossfadeAlbums: Bool
//    var crossfadeSeconds: Double
//    var crossfadeZero: Double
//    var crossfadeZeroDownload: Double
//    var isCrossfading: Bool
//    var crossfadeTimer: Timer
//    
//    // queue
//    var currentQueueItem: QueueItem? = nil // UPDATE
//    var trackQueue: [QueueItem] = [] // UPDATE
//    var sessionHistory: [QueueItem] = [] // UPDATE
//    var didAddFromRepeat: Bool = false
//    var repeatMode: RepeatMode = .off
//    
//    // suggestions
//    var shouldSuggestPlaylistCreation: Bool = false
//    var hasSuggestedPlaylistCreation: Bool = false
//    
//    // controls
//    var lastWaveDepth: (Bool, Double, Bool) = (false, 0, false) // (last, time, valid)
//    var notificationManager: NotificationManager = NotificationManager()
//    
//    // transport
//    var commandCenterAlreadyLoaded: Bool
//    var currentlyTryingInfoCenterAlbumArtUpdate: Bool
//    var nowPlayingInfo:[String : Any]? = [:]
//    var isUpdatingInfoCenter: Bool = false
//    
//    // synced timer
//    var syncedTimerInterval: Double = 1 // actorize
//    var syncedTimer: Timer? = nil // actorize
//    var timerMidFire: Bool = false // actorize
//    
//    
//    init () {
//        // player
//        self.player = PlayerEngine()
//        self.elapsedTime = 0
//        self.durationSeconds = 0.9
//        self.elapsedNormal = 0
//        self.appVolume = 1
//        
//        // crossfade
//        self.crossfadeAlbums = UserDefaults.standard.bool(forKey: "crossfadeAlbums")
//        self.crossfadeSeconds = UserDefaults.standard.double(forKey: "crossfadeSeconds") == 0 ? 0.15 : UserDefaults.standard.double(forKey: "crossfadeSeconds")
//        self.crossfadeZero = 0.15
//        self.crossfadeZeroDownload = 0.05
//        self.isCrossfading = false
//        self.crossfadeTimer = Timer()
//        
//        // queue
//        self.didAddFromRepeat = false
//        
//        // transport
//        self.commandCenterAlreadyLoaded = false
//        self.currentlyTryingInfoCenterAlbumArtUpdate = false
//        
//        //setAudioSession()
//        
//        Task {
//            //update timer
//            await self.update_timer(to: 0.1)
//            
//            //initialize media center
//            await self.setupRemoteTransportControls()
//        }
//    }
//    
//    func setIsPlaying(to: Bool) {
//        if (to == true) {
//            try? self.audioSession.setActive(true)
//        }
//        self.isPlaying = to
//    }
//    
//    func update_timer(to interval: Double) {
//        if self.syncedTimerInterval == interval {
//            return
//        }
//        self.syncedTimerInterval = interval
//        
//        Task { [weak self] in
//            await self?.runTimerLoop(interval: interval)
//        }
//    }
//
//    private func runTimerLoop(interval: Double) async {
//        while self.syncedTimerInterval == interval {
//            await self.timer_fired()
//            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
//        }
//    }
//
//    func timer_fired() async {
//        if self.timerMidFire == false {
//            self.timerMidFire = true
//            await self.syncPlayingTimeControls()
//            await self.updateQueueItemsUI()
//            await self.update_elapsed_time()
//            await self.repeat_check()
//            await self.crossfade_check()
//            await self.try_auto_skip_if_necessary()
//            self.timerMidFire = false
//        }
//    }
//    
//    func updateQueueItemsUI() async {
////        await self.currentQueueItem?.updateUI()
////        for historyItem in self.sessionHistory {
////            await historyItem.updateUI()
////        }
////        for queueItem in self.trackQueue {
////            await queueItem.updateUI()
////        }
//    }
//    
//    func end_song_check() async {
//        if (self.durationSeconds - self.elapsedTime < 0.01) {
//            await self.playerForward()
//        }
//    }
//    
//    func setRepeatMode(to: RepeatMode) {
//        self.repeatMode = to
//    }
//    
//    func setAppVolume(to: Float) {
//        self.appVolume = to
//    }
//}
