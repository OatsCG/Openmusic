//
//  PMSuggestions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

// @AppStorage("DisableQueuingSuggestions") var DisableQueuingSuggestions: Bool = false

extension PlayerManager {
    func setCurrentVibe(vibe: VibeObject) {
        withAnimation {
            self.currentVibe = vibe
        }
        self.addSuggestions()
    }
    
    func clearVibe() {
        withAnimation {
            self.currentVibe = nil
        }
    }
    
    @MainActor func addSuggestions() {
        guard self.trackQueue.count < 10 else {
            return
        }
        guard UserDefaults.standard.bool(forKey: "DisableQueuingSuggestions") == false else {
            return
        }
        
        if let vibe = self.currentVibe {
            self.fetchSuggestionsModel.runSearch(vibe: vibe, playerManager: self)
        } else {
            if self.currentQueueItem != nil {
                let songs: [NaiveTrack] = self.getEnjoyedSongsNaive(limit: 5)
                self.fetchSuggestionsModel.runSearch(songs: songs, playerManager: self)
            }
        }
    }
    
    func getEnjoyedSongs(limit: Int) -> [QueueItem] {
        // get last 5 songs in queue.
        // if no songs in queue, get most recent 4 enjoyed songs in history plus current song
        // if no songs in history, use current song
        
        var lastInQueue: [QueueItem] = self.trackQueue.suffix(5)
        if lastInQueue.count > 0 {
            if lastInQueue.count == 5 {
                return lastInQueue
            } else if let currentQueueItem = self.currentQueueItem {
                lastInQueue.insert(currentQueueItem, at: 0)
                return lastInQueue
            } else {
                return []
            }
        } else {
            var recentInHistory: [QueueItem] = self.sessionHistory.suffix(4)
            if let currentQueueItem = self.currentQueueItem {
                recentInHistory.append(currentQueueItem)
            }
            return recentInHistory
        }
    }
    
    func getEnjoyedSongsNaive(limit: Int) -> [NaiveTrack] {
        var songs: [NaiveTrack] = []
        for song in self.getEnjoyedSongs(limit: 5) {
            songs.append(NaiveTrack(title: song.Track.Title, album: song.Track.Album.Title, artists: stringArtists(artistlist: song.Track.Album.Artists)))
        }
        return songs
    }
    
    func trySuggestingPlaylistCreation() {
        if (self.shouldSuggestPlaylistCreation == true) {
            return
        } else {
            if (self.hasSuggestedPlaylistCreation == true) {
                return
            } else {
                let enjoyedHistory: [QueueItem] = self.sessionHistory.filter({ $0.wasSongEnjoyed == true })
                let enjoyedCount: Int = enjoyedHistory.count
                if (enjoyedCount > 10) {
                    let importedTracks: [ImportedTrack] = enjoyedHistory.compactMap { $0.Track as? ImportedTrack }
                    let importedCount: Int = importedTracks.count
                    if (importedCount > 10) {
                        withAnimation {
                            self.shouldSuggestPlaylistCreation = true
                        }
                    }
                }
            }
        }
    }
}
