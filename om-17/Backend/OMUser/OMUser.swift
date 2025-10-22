//
//  User.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI

@MainActor
@Observable class OMUser {
    var userID: String
    var userName: String
    var profilePicture: String? = nil
    var discordID: String? = nil
    var likedSongs: [String] // TrackIDs
    
    init() {
        userID = ""
        userName = ""
        profilePicture = UserDefaults.standard.string(forKey: "User_profilePicture")
        likedSongs = []
        
        userID = getUUID()
        userName = getName()
        discordID = getDiscordID()
        updatePrivateLikedSongs()
    }
    
    func getUUID() -> String {
        if let storedUUID = UserDefaults.standard.string(forKey: "User_userID") {
            return storedUUID
        }
        let id = UUID().uuidString
        UserDefaults.standard.setValue(id, forKey: "User_userID")
        return id
    }
    
    func getName() -> String {
        if let storedName = UserDefaults.standard.string(forKey: "User_userName") {
            return storedName
        }
        let name = "New User"
        UserDefaults.standard.setValue(name, forKey: "User_userName")
        return name
    }
    
    func getDiscordID() -> String? {
        if let storedDiscordID = UserDefaults.standard.string(forKey: "User_discordID") {
            return storedDiscordID
        }
        return nil
    }
    
    func updateName(to newName: String) {
        userName = newName
        UserDefaults.standard.setValue(newName, forKey: "User_userName")
    }
    
    func updateDiscordCode(to newCode: String?) {
        discordID = newCode
        UserDefaults.standard.setValue(newCode, forKey: "User_discordID")
    }
}
