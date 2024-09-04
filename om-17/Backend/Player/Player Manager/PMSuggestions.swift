//
//  PMSuggestions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

// @AppStorage("DisableQueuingSuggestions") var DisableQueuingSuggestions: Bool = false

extension PlayerManager {
    func addSuggestions() {
        guard self.trackQueue.count < 10 else {
            return
        }
        guard UserDefaults.standard.bool(forKey: "DisableQueuingSuggestions") == false else {
            return
        }
        
        if self.currentQueueItem != nil {
            let songs: [NaiveTrack] = self.getEnjoyedSongsNaive(limit: 5)
            self.fetchSuggestionsModel.runSearch(songs: songs, playerManager: self)
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
}
