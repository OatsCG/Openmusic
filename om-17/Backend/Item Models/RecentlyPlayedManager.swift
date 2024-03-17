//
//  RecentlyPlayedManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-29.
//

import SwiftUI

class RecentlyPlayedManager {
    static func getRecentTracks() -> [FetchedTrack] {
        let tracksString: String? = UserDefaults.standard.string(forKey: "recentlyPlayed")
        if (tracksString != nil) {
            let decodedTracks: [FetchedTrack] = RecentlyPlayedManager.decodeRecentTracks(tracks: tracksString!)
            return decodedTracks
        }
        return []
    }
    
    static func prependRecentTrack(track: FetchedTrack?) {
        print("IN RECENT TRACK")
        if (track == nil) {
            print("TRACK WAS NIL")
            return
        } else {
            var tracks: [FetchedTrack] = RecentlyPlayedManager.getRecentTracks()
            print("GOT EXISTING TRACKS")
            //check if exists. if it does, remove all instances and then prepend
            tracks = Array(tracks.filter{ $0.TrackID != track?.TrackID }.prefix(50))
            tracks.insert(track!, at: 0)
            print("INSERTED")
            let encodedTracks: String = RecentlyPlayedManager.encodeRecentTracks(tracks: tracks)
            print("WRITING")
            UserDefaults.standard.set(encodedTracks, forKey: "recentlyPlayed")
            print("WROTE")
        }
    }
    
    static func decodeRecentTracks(tracks: String) -> [FetchedTrack] {
        var trackObjects: [FetchedTrack] = []
        let trackStrings: [String] = tracks.components(separatedBy: "<FETCHEDTRACKSTRINGSEP>")
        let decoder = JSONDecoder()
        for trackString in trackStrings {
            if let jsonData = trackString.data(using: .utf8) {
                do {
                    let trackObject: FetchedTrack = try decoder.decode(FetchedTrack.self, from: jsonData)
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
        self.timePlayed = Date()
    }
}
