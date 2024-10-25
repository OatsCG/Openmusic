//
//  User.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI

@MainActor
@Observable class OMUser {
    // main
    var userID: String
    var userName: String
    var profilePicture: String? = nil
    var discordID: String? = nil
    
    // liked songs
    var likedSongs: [String] // TrackIDs
    
    
    init() {
        self.userID = ""
        self.userName = ""
        self.profilePicture = UserDefaults.standard.string(forKey: "User_profilePicture")
        self.likedSongs = []
        
        self.userID = self.getUUID()
        self.userName = self.getName()
        self.discordID = self.getDiscordID()
        self.updatePrivateLikedSongs()
    }
    
    func getUUID() -> String {
        let storedUUID: String? = UserDefaults.standard.string(forKey: "User_userID")
        var toset: String
        
        if let storedUUID = storedUUID {
            toset = storedUUID
        } else {
            toset = UUID().uuidString
            UserDefaults.standard.setValue(toset, forKey: "User_userID")
        }
        return toset
    }
    
    func getName() -> String {
        let storedName: String? = UserDefaults.standard.string(forKey: "User_userName")
        var toset: String
        if let storedName = storedName {
            toset = storedName
        } else {
            toset = "New User"
            UserDefaults.standard.setValue(toset, forKey: "User_userName")
        }
        return toset
    }
    
    func getDiscordID() -> String? {
        let storedDiscordID: String? = UserDefaults.standard.string(forKey: "User_discordID")
        var toset: String? = nil
        if let storedDiscordID = storedDiscordID {
            toset = storedDiscordID
        }
        return toset
    }
    
    func updateName(to newName: String) {
        self.userName = newName
        UserDefaults.standard.setValue(newName, forKey: "User_userName")
    }
    
    func updateDiscordCode(to newCode: String?) {
        self.discordID = newCode
        UserDefaults.standard.setValue(newCode, forKey: "User_discordID")
    }
}



