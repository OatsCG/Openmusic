//
//  ipAddress.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    var networkService: NetworkService
    
    init() {
        let serverType: String = UserDefaults.standard.string(forKey: "ServerType") ?? ""
        if let type = ServerType(rawValue: serverType) {
            switch type {
            case .navidrome:
                self.networkService = NavidromeNetworkService()
            case .openmusic:
                self.networkService = OpenmusicNetworkService()
            }
        } else {
            self.networkService = OpenmusicNetworkService()
        }
    }
    
    func updateGlobalIPAddress(with newValue: String, type: ServerType) {
        UserDefaults.standard.set(newValue, forKey: "globalIPAddress")
        UserDefaults.standard.set(type.rawValue, forKey: "ServerType")
        switch type {
        case .navidrome:
            self.networkService = NavidromeNetworkService()
        case .openmusic:
            self.networkService = OpenmusicNetworkService()
        }
    }
    
    static func globalIPAddress() -> String {
        let defaultIP: String = UserDefaults.standard.string(forKey: "globalIPAddress") ?? ""
        if (defaultIP == "") {
            return ""
        } else {
            return defaultIP
        }
    }
}


protocol NetworkService {
    func baseURL() -> String
    func getEndpointURL(_ endpoint: Endpoint) -> String
}


class OpenmusicNetworkService: NetworkService {
    func baseURL() -> String {
        return NetworkManager.globalIPAddress()
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        return switch endpoint {
        case .status:
            "\(baseURL())/status"
        case .explore:
            "\(baseURL())/explore"
        case .vibes:
            "\(baseURL())/vibes"
        case .search(q: let q):
            "\(baseURL())/search?q=\(q)"
        case .quick(q: let q):
            "\(baseURL())/quick?q=\(q)"
        case .album(id: let id):
            "\(baseURL())/album?id=\(id)"
        case .artist(id: let id):
            "\(baseURL())/artist?id=\(id)"
        case .random:
            "\(baseURL())/random"
        case .playlistinfo(platform: let platform, id: let id):
            "\(baseURL())/playlistinfo?platform=\(platform)&id=\(id)"
        case .ampVideo(id: let id):
            "\(baseURL())/ampVideo?id=\(id)"
        case .playlisttracks(platform: let platform, id: let id):
            "\(baseURL())/playlisttracks?platform=\(platform)&id=\(id)"
        case .exact(song: let song, album: let album, artist: let artist):
            "\(baseURL())/exact?song=\(song)&album=\(album)&artist=\(artist)"
        case .suggest(songs: let songs):
            "\(baseURL())/suggest?songs=\(songs)"
        case .suggestVibe(genre: let genre, acousticness: let acousticness, danceability: let danceability, energy: let energy, instrumentalness: let instrumentalness, liveness: let liveness, mode: let mode, speechiness: let speechiness, valence: let valence):
            "\(baseURL())/suggestVibe?genre=\(genre)&acousticness=\(acousticness)&danceability=\(danceability)&energy=\(energy)&instrumentalness=\(instrumentalness)&liveness=\(liveness)&mode=\(mode)&speechiness=\(speechiness)&valence=\(valence)"
        case .playback(id: let id):
            "\(baseURL())/playback?id=\(id)"
        case .image(id: let id, w: let w, h: let h):
            "https://lh3.googleusercontent.com/\(id)=w\(w)-h\(h)-p-l90-rj"
        }
    }
    
    func decode(data: Data, to: Decodable.Type) {
        
    }
}

class NavidromeNetworkService: NetworkService {
    func baseURL() -> String {
        return ""
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        return ""
    }
    
    
}


enum ServerType: String, Codable {
    case openmusic, navidrome
}

enum Endpoint {
    case status,
        explore,
        vibes,
        search(q: String),
        quick(q: String),
        album(id: String),
        artist(id: String),
        random,
        playlistinfo(platform: String, id: String),
        ampVideo(id: String),
        playlisttracks(platform: String, id: String),
        exact(song: String, album: String, artist: String),
        suggest(songs: String),
        suggestVibe(genre: String, acousticness: Float, danceability: Float, energy: Float, instrumentalness: Float, liveness: Float, mode: Int, speechiness: Float, valence: Float),
        playback(id: String),
        image(id: String, w: Int, h: Int)
}
