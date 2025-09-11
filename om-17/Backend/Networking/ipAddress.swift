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
    
    func updateGlobalIPAddress(with newValue: String, type: ServerType, u: String, p: String) {
        UserDefaults.standard.set(newValue, forKey: "globalIPAddress")
        UserDefaults.standard.set(type.rawValue, forKey: "ServerType")
        UserDefaults.standard.set(u, forKey: "ServerUsername")
        UserDefaults.standard.set(p, forKey: "ServerPassword")
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
    
    func decodeServerStatus(_ data: Data) throws -> ServerStatus
    func decodeExploreResults(_ data: Data) throws -> ExploreResults
    func decodeVibeShelf(_ data: Data) throws -> VibeShelf
    func decodeSearchResults(_ data: Data) throws -> SearchResults
    func decodeFetchedTracks(_ data: Data) throws -> FetchedTracks
    func decodeFetchedAlbum(_ data: Data) throws -> FetchedAlbum
    func decodeFetchedArtist(_ data: Data) throws -> FetchedArtist
    func decodeRandomTracks(_ data: Data) throws -> RandomTracks
    func decodeFetchedPlaylistInfo(_ data: Data) throws -> FetchedPlaylistInfo
    func decodeFetchedPlaylistInfoTracks(_ data: Data) throws -> FetchedPlaylistInfoTracks
    func decodeImportedTracks(_ data: Data) throws -> ImportedTracks
    func decodeFetchedPlayback(_ data: Data) throws -> FetchedPlayback
}


class OpenmusicNetworkService: NetworkService {
    let decoder = JSONDecoder()
    
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
    
    func decodeServerStatus(_ data: Data) throws -> ServerStatus {
        return try decoder.decode(ServerStatus.self, from: data)
    }
    
    func decodeExploreResults(_ data: Data) throws -> ExploreResults {
        return try decoder.decode(ExploreResults.self, from: data)
    }
    
    func decodeVibeShelf(_ data: Data) throws -> VibeShelf {
        return try decoder.decode(VibeShelf.self, from: data)
    }
    
    func decodeSearchResults(_ data: Data) throws -> SearchResults {
        return try decoder.decode(SearchResults.self, from: data)
    }
    
    func decodeFetchedTracks(_ data: Data) throws -> FetchedTracks {
        return try decoder.decode(FetchedTracks.self, from: data)
    }
    
    func decodeFetchedAlbum(_ data: Data) throws -> FetchedAlbum {
        return try decoder.decode(FetchedAlbum.self, from: data)
    }
    
    func decodeFetchedArtist(_ data: Data) throws -> FetchedArtist {
        return try decoder.decode(FetchedArtist.self, from: data)
    }
    
    func decodeRandomTracks(_ data: Data) throws -> RandomTracks {
        return try decoder.decode(RandomTracks.self, from: data)
    }
    
    func decodeFetchedPlaylistInfo(_ data: Data) throws -> FetchedPlaylistInfo {
        return try decoder.decode(FetchedPlaylistInfo.self, from: data)
    }
    
    func decodeFetchedPlaylistInfoTracks(_ data: Data) throws -> FetchedPlaylistInfoTracks {
        return try decoder.decode(FetchedPlaylistInfoTracks.self, from: data)
    }
    
    func decodeImportedTracks(_ data: Data) throws -> ImportedTracks {
        return try decoder.decode(ImportedTracks.self, from: data)
    }
    
    func decodeFetchedPlayback(_ data: Data) throws -> FetchedPlayback {
        return try decoder.decode(FetchedPlayback.self, from: data)
    }
}

class NavidromeNetworkService: NetworkService {
    var u: String
    var p: String
    let params: String = "f=json&v=1.8.0&c=openmusic"
    
    init(u: String, p: String) {
        self.u = u
        self.p = p
    }
    
    init() {
        self.u = ""
        self.p = ""
    }
    
    func baseURL() -> String {
        return NetworkManager.globalIPAddress()
    }
    
    func getEndpointURL(_ endpoint: Endpoint, ip: String) -> String {
        return switch endpoint {
        case .status:
            "\(ip)/rest/ping?\(params)&u=\(u)&p=\(p)"
        default:
            "\(ip)/rest/ping?\(params)&u=\(u)&p=\(p)"
        }
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        return switch endpoint {
        case .status:
            "\(baseURL())/rest/ping"
        default:
            "\(baseURL())/rest/ping"
        }
    }
    
    static func decodeStatus(data: Data) {
        
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
