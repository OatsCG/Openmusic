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
            currentVibe = vibe
        }
        addSuggestions()
    }
    
    func clearVibe() {
        withAnimation {
            currentVibe = nil
        }
    }
    
    @MainActor func addSuggestions(noQuestionsAsked: Bool = false) {
        guard trackQueue.count < 10 else {
            return
        }
        guard UserDefaults.standard.bool(forKey: "DisableQueuingSuggestions") == false else {
            return
        }
        if let vibe = currentVibe {
            fetchSuggestionsModel.runSearch(vibe: vibe, playerManager: self)
        } else {
            if currentQueueItem != nil {
                let songs: [NaiveTrack] = getEnjoyedSongsNaive(limit: 5)
                fetchSuggestionsModel.runSearch(songs: songs, playerManager: self)
            }
        }
    }
    
    func getEnjoyedSongs(limit: Int) -> [QueueItem] {
        // Try to get the last 5 songs from the queue
        var songs = Array(self.trackQueue.suffix(5))
        
        if songs.count < 5 {
            // If there are fewer than 5 songs in the queue, check for the current song
            if let currentQueueItem {
                songs.insert(currentQueueItem, at: 0)
                // If the queue is empty and we need more songs, add up to 4 recent songs from history
                if songs.count == 1 {
                    songs = Array(sessionHistory.filter({ $0.wasSongEnjoyed }).suffix(4))
                    songs.append(currentQueueItem)
                }
            }
        }
        return songs
    }
    
    func getEnjoyedSongsNaive(limit: Int) -> [NaiveTrack] {
        var songs: [NaiveTrack] = []
        for song in getEnjoyedSongs(limit: 5) {
            songs.append(NaiveTrack(title: song.Track.Title, album: song.Track.Album.Title, artists: stringArtists(artistlist: song.Track.Album.Artists)))
        }
        return songs
    }
    
    func trySuggestingPlaylistCreation() {
        if !shouldSuggestPlaylistCreation && !hasSuggestedPlaylistCreation {
            let enjoyedHistory: [QueueItem] = sessionHistory.filter({ $0.wasSongEnjoyed })
            let enjoyedCount: Int = enjoyedHistory.count
            if enjoyedCount > 10 {
                let importedTracks: [ImportedTrack] = enjoyedHistory.compactMap { $0.Track as? ImportedTrack }
                let importedCount: Int = importedTracks.count
                if importedCount > 10 {
                    withAnimation {
                        shouldSuggestPlaylistCreation = true
                    }
                }
            }
        }
    }
}
