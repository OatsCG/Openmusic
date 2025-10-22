//
//  UserLikedSongs.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI

extension OMUser {
    func updatePrivateLikedSongs() {
        withAnimation {
            likedSongs = decodeLikedSongs()
        }
    }
    
    func addLikedSong(track: any Track) {
        if !likedSongs.contains(where: { $0 == track.TrackID }) {
            withAnimation {
                likedSongs.append(track.TrackID)
            }
            storeLikedSongs(trackIDs: likedSongs)
            ToastManager.shared.propose(toast: Toast.likedSong(track.Album.Artwork))
        }
        updatePrivateLikedSongs()
    }
    
    func removeLikedSong(track: any Track) {
        if likedSongs.contains(where: { $0 == track.TrackID }) {
            withAnimation {
                likedSongs.removeAll(where: { $0 == track.TrackID })
            }
            storeLikedSongs(trackIDs: likedSongs)
        }
        updatePrivateLikedSongs()
    }
    
    func isSongLiked(track: any Track) -> Bool {
        return likedSongs.contains(where: { $0 == track.TrackID })
    }
    
    private func decodeLikedSongs() -> [String] {
        if let storedLiked = UserDefaults.standard.string(forKey: "User_likedSongs") {
            let splitLiked = storedLiked.components(separatedBy: "\n")
            if !splitLiked.isEmpty {
                return splitLiked
            }
        }
        return []
    }
    
    private func storeLikedSongs(trackIDs: [String]) {
        if !trackIDs.isEmpty {
            UserDefaults.standard.setValue(trackIDs.joined(separator: "\n"), forKey: "User_likedSongs")
        } else {
            UserDefaults.standard.setValue("", forKey: "User_likedSongs")
        }
    }
}
