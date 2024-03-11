//
//  User.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI

@Observable class OMUser {
    // main
    var userID: String
    var profilePicture: String?
    
    // liked songs
    var likedSongs: [String] // TrackIDs
    
    
    init() {
        let storedUUID: String? = UserDefaults.standard.string(forKey: "User_userID")
        var toset: String
        if (storedUUID == nil) {
            toset = UUID().uuidString
            UserDefaults.standard.setValue(toset, forKey: "User_userID")
        } else {
            toset = storedUUID!
        }
        self.userID = toset
        self.profilePicture = UserDefaults.standard.string(forKey: "User_profilePicture")
        self.likedSongs = []
        self.updatePrivateLikedSongs()
    }
    
}



