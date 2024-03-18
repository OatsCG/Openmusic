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
        withAnimation {
            self.likedSongs = likedSongs
        }
    }
    
    func addLikedSong(track: any Track) {
        //var likedSongs: [String] = decodeLikedSongs()
        if (self.likedSongs.contains(where: { $0 == track.TrackID }) == false) {
            withAnimation {
                self.likedSongs.append(track.TrackID)
            }
            storeLikedSongs(trackIDs: self.likedSongs)
            ToastManager.shared.propose(toast: Toast.likedSong(track.Album.Artwork))
        }
        updatePrivateLikedSongs()
    }
    
    func removeLikedSong(track: any Track) {
        //var likedSongs: [String] = decodeLikedSongs()
        if (self.likedSongs.contains(where: { $0 == track.TrackID })) {
            withAnimation {
                self.likedSongs.removeAll(where: { $0 == track.TrackID })
            }
            storeLikedSongs(trackIDs: self.likedSongs)
        }
        updatePrivateLikedSongs()
    }
    
    func isSongLiked(track: any Track) -> Bool {
        if (self.likedSongs.contains(where: { $0 == track.TrackID })) {
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
