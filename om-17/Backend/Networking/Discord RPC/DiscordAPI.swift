//
//  DiscordAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-06-08.
//

//import Foundation
//import Discord
//
//let clientId = "1249112062899130538"
//let accessToken = "X1WenxSLqosU-Mndl_tfokW5vCzlBhsw" // Replace with your user's access token
//
//
//class DiscordRPC: DiscordClientDelegate {
//    func client(_ client: Discord.DiscordClient, didConnect connected: Bool) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didDisconnectWithReason reason: Discord.DiscordGatewayCloseReason, closed: Bool) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, shouldAttemptResuming reason: Discord.DiscordGatewayCloseReason, closed: Bool) -> Bool {
//        return true
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateChannel channel: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didDeleteChannel channel: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateChannel channel: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateThread thread: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didDeleteThread thread: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateThread thread: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didDeleteGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didAddGuildMember member: Discord.DiscordGuildMember) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didRemoveGuildMember member: Discord.DiscordGuildMember) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateGuildMember member: Discord.DiscordGuildMember) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateMessage message: Discord.DiscordMessage) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateMessage message: Discord.DiscordMessage) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didAddReaction reaction: Discord.DiscordEmoji, toMessage messageID: Discord.MessageID, onChannel channel: Discord.DiscordChannel, user userID: Discord.UserID) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didRemoveReaction reaction: Discord.DiscordEmoji, fromMessage messageID: Discord.MessageID, onChannel channel: Discord.DiscordChannel, user userID: Discord.UserID) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didRemoveAllReactionsFrom messageID: Discord.MessageID, onChannel channel: Discord.DiscordChannel) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateRole role: Discord.DiscordRole, onGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didDeleteRole role: Discord.DiscordRole, fromGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateRole role: Discord.DiscordRole, onGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didReceivePresenceUpdate presence: Discord.DiscordPresence) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didCreateInteraction interaction: Discord.DiscordInteraction) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didReceiveReady ready: Discord.DiscordReadyEvent) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didReceiveVoiceStateUpdate voiceState: Discord.DiscordVoiceState) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didHandleGuildMemberChunk chunk: [Discord.DiscordGuildMember], forGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didNotHandleDispatchEvent event: Discord.DiscordDispatchEvent) {
//        return
//    }
//    
//    func client(_ client: Discord.DiscordClient, didUpdateEmojis emojis: [Discord.DiscordEmoji], onGuild guild: Discord.DiscordGuild) {
//        return
//    }
//    
//    var client: DiscordClient? = nil
//    
//    init() {
//        self.client = DiscordClient(token: DiscordToken(rawValue: accessToken), delegate: self)
//    }
//    
//    func sendActivityUpdate(song: String) {
//        self.client?.setPresence(DiscordPresenceUpdate(activities: [.init(name: "Openmusic", type: .listening)]))
//    }
//}
