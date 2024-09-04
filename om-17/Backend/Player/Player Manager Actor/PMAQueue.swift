//
//  PMAQueue.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

extension PlayerManagerActor {
    func queue_start_over() {
        self.currentQueueItem = nil
        self.player = PlayerEngine()
        self.player.set_volume(to: self.appVolume)
        self.trackQueue = self.sessionHistory
        self.sessionHistory = []
        self.shouldSuggestPlaylistCreation = false
        self.hasSuggestedPlaylistCreation = false
    }
    
    func clear_all_queue(appVolume: Float) async {
        await self.currentQueueItem?.clearPlayback()
        self.reset_session_history()
        self.queue_start_over()
    }
    
    func reset_session_history() {
        self.sessionHistory = []
        self.shouldSuggestPlaylistCreation = false
        self.hasSuggestedPlaylistCreation = false
    }
    
    func clear_suggestions() async {
        var temparr: [QueueItem] = []
        for sessionHistoryItem in self.sessionHistory {
            if await sessionHistoryItem.Track as? ImportedTrack == nil {
                temparr.append(sessionHistoryItem)
            }
        }
        self.sessionHistory = temparr
    }
    
    func reset_up_next() {
        self.trackQueue = []
    }
    
    func fresh_play(track: any Track, explicit: Bool? = nil) async {
        await self.clear_suggestions()
        await self.queue_next(track: track, explicit: explicit)
        await self.playerForward()
    }
    
    func fresh_play_multiple(tracks: [any Track]) async {
        await self.currentQueueItem?.clearPlayback()
        self.reset_session_history()
        self.queue_start_over()
        await self.queue_songs(tracks: tracks)
        await self.play()
    }
    
    func fresh_play_multiple(tracks: [PlaylistItem]) async {
        await self.currentQueueItem?.clearPlayback()
        self.reset_session_history()
        self.queue_start_over()
        await self.queue_songs(tracks: tracks.filter({ $0.importData.status == .success }).map{$0.track})
        await self.play()
    }
    
    func queue_song(track: any Track, explicit: Bool? = nil) async {
        await self.trackQueue.append(QueueItem(from: track, explicit: explicit))
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(track.Album.Artwork))
    }
    
    func queue_song(queueItem: QueueItem) async {
        self.trackQueue.append(queueItem)
        await self.prime_next_song()
        await ToastManager.shared.propose(toast: Toast.queuelater(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs(tracks: [any Track], wasSuggested: Bool = false) async {
        for track in tracks {
            await self.trackQueue.append(QueueItem(from: track))
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.Album.Artwork, count: tracks.count, wasSuggested: wasSuggested))
    }
    
    func queue_songs(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            await self.trackQueue.append(QueueItem(from: track))
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuelater(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_next(track: any Track, explicit: Bool? = nil) async {
        await self.trackQueue.insert(QueueItem(from: track, explicit: explicit), at: 0)
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(track.Album.Artwork))
    }
    
    func queue_next(queueItem: QueueItem) async {
        self.trackQueue.insert(queueItem, at: 0)
        await self.prime_next_song()
        await ToastManager.shared.propose(toast: Toast.queuenext(queueItem.Track.Album.Artwork))
    }
    
    func queue_songs_next(tracks: [any Track]) async {
        for track in tracks.reversed() {
            await self.trackQueue.insert(QueueItem(from: track), at: 0)
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_next(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}).reversed() {
            await self.trackQueue.insert(QueueItem(from: track), at: 0)
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuenext(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func queue_randomly(track: any Track, explicit: Bool? = nil) async {
        await self.trackQueue.insert(QueueItem(from: track, explicit: explicit), at: Int.random(in: 0..<self.trackQueue.count + 1))
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(track.Album.Artwork))
    }
    
    func queue_songs_randomly(tracks: [any Track]) async {
        for track in tracks {
            await self.trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<self.trackQueue.count + 1))
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.Album.Artwork, count: tracks.count))
    }
    
    func queue_songs_randomly(tracks: [PlaylistItem]) async {
        for track in tracks.filter({ $0.importData.status == .success }).map({$0.track}) {
            await self.trackQueue.insert(QueueItem(from: track), at: Int.random(in: 0..<self.trackQueue.count + 1))
        }
        await self.prime_next_song()
        ToastManager.shared.propose(toast: Toast.queuerandom(tracks.first?.track.Album.Artwork, count: tracks.count))
    }
    
    func remove_from_queue(at: Int) async {
        if (at >= 0 && at < self.trackQueue.count) {
            self.trackQueue.remove(at: at)
            await self.prime_next_song()
        }
    }
    
    func try_auto_skip_if_necessary() async {
        if await (self.currentQueueItem?.isDownloaded == false) {
            if await self.currentQueueItem?.primeStatus == .failed {
                await self.currentQueueItem?.setPrimeStatus(.passed)
                await self.playerForward(userInitiated: true)
                return
            }
        }
    }
}
