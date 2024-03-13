//
//  PMSuggestions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-25.
//

import SwiftUI

extension PlayerManager {
    func addSuggestions() {
        guard self.trackQueue.count < 10 else {
            return
        }
        if self.currentQueueItem != nil {
            var songs: [NaiveTrack] = []
            for song in getEnjoyedSongs(limit: 5) {
                songs.append(NaiveTrack(title: song.Track.Title, album: song.Track.Album.Title, artists: stringArtists(artistlist: song.Track.Album.Artists)))
            }
            self.fetchSuggestionsModel.runSearch(songs: songs, playerManager: self)
        }
    }
    
    func getEnjoyedSongs(limit: Int) -> [QueueItem] {
        let enjoyedSongs: [QueueItem] = self.sessionHistory.filter({ $0.wasSongEnjoyed == true })
        if (enjoyedSongs.count > 0) {
            return enjoyedSongs.suffix(limit)
        } else {
            if (self.sessionHistory.count > 0) {
                return self.sessionHistory.suffix(limit)
            } else {
                if (self.currentQueueItem != nil) {
                    return [self.currentQueueItem!]
                } else {
                    let recentSongs: [QueueItem] = RecentlyPlayedManager.getRecentTracks().map({ return QueueItem(from: $0) })
                    return recentSongs.suffix(limit)
                }
            }
        }
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
