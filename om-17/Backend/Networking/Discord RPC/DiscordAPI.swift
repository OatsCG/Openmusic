//
//  DiscordAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-06-08.
//

import Foundation
import Starscream

class DiscordRPC {
    var socket: WebSocket!
    var token: String

    init(token: String) {
        self.token = token
    }
    
    func connect() {
        return
    }
    
    func sendActivityUpdate(song: String) {
        let url = URL(string: "https://discord.com/api/v9/users/@me/settings")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let activity: [String: Any] = [
            "custom_status": [
                "text": "Listening to \(song)"
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: activity, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating activity: \(error)")
                return
            }
            print("Activity updated successfully")
        }
        task.resume()
    }
}


//class DiscordRPC: WebSocketDelegate {
//    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
//        print(event)
//    }
//    
//    var socket: WebSocket!
//    var token: String
//
//    init(token: String) {
//        self.token = token
//        var request = URLRequest(url: URL(string: "wss://gateway.discord.gg/?v=6&encoding=json")!)
//        socket = WebSocket(request: request)
//        socket.delegate = self
//    }
//
//    func connect() {
//        socket.connect()
//    }
//
//    func sendActivityUpdate(song: String) {
//        let activity = [
//            "op": 3,
//            "d": [
//                "since": Int(Date().timeIntervalSince1970 * 1000),
//                "game": [
//                    "name": song,
//                    "type": 2, // 2 for Listening to
//                    "details": "Listening to \(song)"
//                ]
//            ]
//        ] as [String : Any]
//
//        if let data = try? JSONSerialization.data(withJSONObject: activity, options: []) {
//            socket.write(data: data)
//        }
//    }
//
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("Connected to Discord RPC")
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("Disconnected from Discord RPC: \(error?.localizedDescription ?? "No error")")
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        guard let jsonData = text.data(using: .utf8),
//              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
//            return
//        }
//
//        if let op = json["op"] as? Int {
//            if op == 10 {
//                // Hello packet, respond with identify
//                let identify = [
//                    "op": 2,
//                    "d": [
//                        "token": self.token,
//                        "properties": [
//                            "$os": "mac",
//                            "$browser": "Openmusic",
//                            "$device": "Openmusic"
//                        ],
//                        "presence": [
//                            "activities": [],
//                            "status": "online",
//                            "since": nil,
//                            "afk": false
//                        ]
//                    ]
//                ] as [String : Any]
//
//                if let data = try? JSONSerialization.data(withJSONObject: identify, options: []) {
//                    socket.write(data: data)
//                }
//            } else if op == 1 {
//                // Heartbeat request, respond with heartbeat
//                let heartbeat = [
//                    "op": 1,
//                    "d": Int(Date().timeIntervalSince1970 * 1000)
//                ] as [String : Any]
//
//                if let data = try? JSONSerialization.data(withJSONObject: heartbeat, options: []) {
//                    socket.write(data: data)
//                }
//            }
//        }
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("Received data: \(data)")
//    }
//}
//
