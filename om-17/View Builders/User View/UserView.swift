//
//  UserView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-04.
//

import SwiftUI

struct UserView: View {
    @Environment(FontManager.self) private var fontManager
    @Environment(PlayerManager.self) private var playerManager
    @Environment(OMUser.self) var omUser
    @State var username: String = ""
    @State var showingDisconnectDiscordAlert: Bool = false
//    @State var discordRPC: DiscordRPC?
    var body: some View {
        Form {
            Section(header: Text("USER ID")) {
                Text(omUser.userID)
                    .foregroundStyle(.secondary)
                    .disabled(true)
            }
            Section(header: Text("USERNAME")) {
                TextField("Name...", text: $username)
                    .onChange(of: username) {
                        omUser.updateName(to: username)
                    }
                    .onAppear {
                        username = omUser.userName
                    }
            }
            
            Section(header: Text("CONNECTIONS")) {
                if let discordID = omUser.discordID {
                    Button(action: {
                        showingDisconnectDiscordAlert = true
                    }) {
                        Text("Discord Connected: \(discordID)")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Button(action: {
                        let discordOAuth: DiscordOAuth = DiscordOAuth()
                        discordOAuth.authorize(omUser: omUser)
                    }) {
                        Text("Connect Discord Account")
                            .foregroundStyle(.primary)
                    }
                }
                
                Button(action: {
//                    discordRPC?.sendActivityUpdate(song: "TEST SONG!")
                }) {
                    Text("Try Updating Discord")
                }
//                .onAppear {
//                    if let discordID = omUser.discordID {
//                        //discordRPC = DiscordRPC(token: discordID)
////                        discordRPC = DiscordRPC()
//                        print("rpc initialized")
//                        //discordRPC?.connect()
//                        print("tried connect")
//                    }
//                }
                .alert("Remove Discord Profile?", isPresented: $showingDisconnectDiscordAlert) {
                    Button(action: {
                        omUser.updateDiscordCode(to: nil)
                    }) {
                        Text("Remove")
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
                
            }
        }
            .navigationTitle("Profile")
    }
}
