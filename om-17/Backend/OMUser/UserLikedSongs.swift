//
//  UserLikedSongs.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI

extension OMUser {
    
    func updatePrivateLikedSongs() {
        let likedSongs: [String] = decodeLikedSongs()
        self.likedSongs = likedSongs
    }
    
    func addLikedSong(TrackID: String) {
        var likedSongs: [String] = decodeLikedSongs()
        if (likedSongs.contains(where: { $0 == TrackID }) == false) {
            likedSongs.append(TrackID)
            storeLikedSongs(trackIDs: likedSongs)
        }
        updatePrivateLikedSongs()
    }
    
    func removeLikedSong(TrackID: String) {
        var likedSongs: [String] = decodeLikedSongs()
        if (likedSongs.contains(where: { $0 == TrackID })) {
            likedSongs.removeAll(where: { $0 == TrackID })
            storeLikedSongs(trackIDs: likedSongs)
        }
        updatePrivateLikedSongs()
    }
    
    func isSongLiked(TrackID: String) -> Bool {
        if (self.likedSongs.contains(where: { $0 == TrackID })) {
            return true
        } else {
            return false
        }
    }
    
    private func decodeLikedSongs() -> [String] {
        let storedLiked: String? = UserDefaults.standard.string(forKey: "User_likedSongs")
        if let storedLiked = storedLiked {
            let splitLiked: [String] = storedLiked.components(separatedBy: "\n")
            if (splitLiked.count > 0) {
                return splitLiked
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    private func storeLikedSongs(trackIDs: [String]) {
        if (trackIDs.count > 0) {
            let joinedLiked: String = trackIDs.joined(separator: "\n")
            UserDefaults.standard.setValue(joinedLiked, forKey: "User_likedSongs")
        } else {
            UserDefaults.standard.setValue("", forKey: "User_likedSongs")
        }
    }
}
