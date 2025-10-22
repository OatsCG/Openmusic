//
//  RecentlyPlayedManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-29.
//

import SwiftUI

class RecentlyPlayedManager {
    static func getRecentTracks() -> [FetchedTrack] {
        if let tracksString = UserDefaults.standard.string(forKey: "recentlyPlayed") {
            return RecentlyPlayedManager.decodeRecentTracks(tracks: tracksString)
        }
        return []
    }
    
    static func prependRecentTrack(track: FetchedTrack?) {
        if let track {
            var tracks: [FetchedTrack] = RecentlyPlayedManager.getRecentTracks()
            //check if exists. if it does, remove all instances and then prepend
            tracks = Array(tracks.filter{ $0.TrackID != track.TrackID }.prefix(50))
            tracks.insert(track, at: 0)
            let encodedTracks: String = RecentlyPlayedManager.encodeRecentTracks(tracks: tracks)
            UserDefaults.standard.set(encodedTracks, forKey: "recentlyPlayed")
        }
    }
    
    static func decodeRecentTracks(tracks: String) -> [FetchedTrack] {
        var trackObjects: [FetchedTrack] = []
        let trackStrings: [String] = tracks.components(separatedBy: "<FETCHEDTRACKSTRINGSEP>")
        for trackString in trackStrings {
            if let jsonData = trackString.data(using: .utf8) {
                do {
                    let trackObject: FetchedTrack = try NetworkManager.shared.networkService.decodeFetchedTrack(jsonData)
                    trackObjects.append(trackObject)
                } catch {
                    continue
                }
            }
        }
        return trackObjects
    }
    
    static func encodeRecentTracks(tracks: [FetchedTrack]) -> String {
        var trackStrings: [String] = []
        let encoder = JSONEncoder()
        for track in tracks {
            do {
                let trackJson = try encoder.encode(track)
                if let jsonString = String(data: trackJson, encoding: .utf8) {
                    trackStrings.append(jsonString)
                }
            } catch {
                continue
            }
        }
        let encodedString: String = trackStrings.joined(separator: "<FETCHEDTRACKSTRINGSEP>")
        return encodedString
    }
}

class RecentTrack {
    var track: any Track
    var timePlayed: Date
    
    init(track: any Track) {
        self.track = track
        timePlayed = Date()
    }
}
