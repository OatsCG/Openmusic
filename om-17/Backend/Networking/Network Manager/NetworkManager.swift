//
//  NetworkManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    var networkService: NetworkService
    var networkLogs: [NetworkLog] = []
    
    init() {
        let serverType = UserDefaults.standard.string(forKey: "ServerType") ?? ""
        if let type = ServerType(rawValue: serverType) {
            switch type {
            case .navidrome:
                networkService = NavidromeNetworkService(u: UserDefaults.standard.string(forKey: "ServerUsername") ?? "", p: UserDefaults.standard.string(forKey: "ServerPassword") ?? "")
            case .openmusic:
                networkService = OpenmusicNetworkService()
            }
        } else {
            networkService = OpenmusicNetworkService()
        }
    }
    
    func fetch<T: Codable>(endpoint: Endpoint, type: T.Type) async throws -> T {
        let urlString = NetworkManager.shared.networkService.getEndpointURL(endpoint)
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        if let d = try decoder(T.self, data: data) {
            return d
        } else {
            throw NSError()
        }
    }
    
    func decoder<T: Codable>(_ t: T.Type, data: Data) throws -> T? {
        if T.self == VibeShelf.self {
            return try NetworkManager.shared.networkService.decodeVibeShelf(data) as? T
        } else if T.self == SearchResults.self {
            return try NetworkManager.shared.networkService.decodeSearchResults(data) as? T
        } else if T.self == FetchedTracks.self {
            return try NetworkManager.shared.networkService.decodeFetchedTracks(data) as? T
        } else if T.self == FetchedAlbum.self {
            return try NetworkManager.shared.networkService.decodeFetchedAlbum(data) as? T
        } else if T.self == FetchedArtist.self {
            return try NetworkManager.shared.networkService.decodeFetchedArtist(data) as? T
        } else if T.self == RandomTracks.self {
            return try NetworkManager.shared.networkService.decodeRandomTracks(data) as? T
        } else if T.self == FetchedPlaylistInfo.self {
            return try NetworkManager.shared.networkService.decodeFetchedPlaylistInfo(data) as? T
        } else if T.self == FetchedPlaylistInfoTracks.self {
            return try NetworkManager.shared.networkService.decodeFetchedPlaylistInfoTracks(data) as? T
        } else if T.self == ImportedTracks.self {
            return try NetworkManager.shared.networkService.decodeImportedTracks(data) as? T
        } else if T.self == FetchedPlayback.self {
            return try NetworkManager.shared.networkService.decodeFetchedPlayback(data) as? T
        } else {
            return nil
        }
    }
    
    func addNetworkLog(url: String) -> UUID {
        let networkLog = NetworkLog(requestURL: url)
        networkLogs.append(networkLog)
        return networkLog.id
    }
    
    func updateLogStatus(id: UUID, to: ResponseStatus) {
        networkLogs.first(where: { $0.id == id })?.responseStatus = to
    }
    
    func updateGlobalIPAddress(with newValue: String, type: ServerType, u: String, p: String) {
        print("UPDATING: \(newValue), \(type)")
        UserDefaults.standard.set(newValue, forKey: "globalIPAddress")
        UserDefaults.standard.set(type.rawValue, forKey: "ServerType")
        UserDefaults.standard.set(u, forKey: "ServerUsername")
        UserDefaults.standard.set(p, forKey: "ServerPassword")
        switch type {
        case .navidrome:
            self.networkService = NavidromeNetworkService(u: u, p: p)
        case .openmusic:
            self.networkService = OpenmusicNetworkService()
        }
    }
    
    static func globalIPAddress() -> String {
        let defaultIP = UserDefaults.standard.string(forKey: "globalIPAddress") ?? ""
        if defaultIP == "" {
            return ""
        } else {
            return defaultIP
        }
    }
}
