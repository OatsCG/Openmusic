//
//  StatusFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-26.
//

import Foundation
import SwiftUI

func getIPAddressType(_ ip: String) async throws -> ServerType {
    let isNavidrome: Bool? = try? await isNavidrome(ip)
    if isNavidrome == true {
        return .navidrome
    } else {
        return .openmusic
    }
}

func isNavidrome(_ ip: String) async throws -> Bool {
    guard let url = URL(string: "\(ip)/rest/ping?f=json") else { return false }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let navidromeServerStatus = try? decoder.decode(NavidromeServerStatus.self, from: data)
    return navidromeServerStatus != nil
}

// Function to fetch server status
func fetchServerStatus(with tempIPAddress: String? = nil, u: String, p: String) async throws -> ServerStatus {
    var urlString = NetworkManager.shared.networkService.getEndpointURL(.status)
    let logID: UUID = NetworkManager.shared.addNetworkLog(url: urlString, endpoint: .status)
    var successData: (any Codable)? = nil
    defer {
        NetworkManager.shared.updateLogStatus(id: logID, with: successData)
    }
    if let tempIPAddress = tempIPAddress {
        let serverType = try await getIPAddressType(tempIPAddress)
        switch serverType {
        case .openmusic:
            urlString = "\(tempIPAddress)/status"
        case .navidrome:
            let statusURL = NavidromeNetworkService(u: u, p: p).getEndpointURL(.status, ip: tempIPAddress)
            guard let url = URL(string: statusURL) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let navidromeServerStatus = try decoder.decode(NavidromeServerStatus.self, from: data)
            var serverStatus = ServerStatus(online: true, title: "Navidrome Server", body: "version \(navidromeServerStatus.subsonicresponse.serverVersion)", footer: "", om_verify: "", type: .navidrome)
            
            if let error = navidromeServerStatus.subsonicresponse.error {
                serverStatus.body = error.message
                serverStatus.footer = "Error code \(error.code)"
                serverStatus.om_verify = "bad"
            }
            successData = serverStatus
            return serverStatus
        }
    }
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    return try NetworkManager.shared.networkService.decodeServerStatus(data)
}

// Actor to manage server status data
actor StatusViewActor {
    private var serverStatus: ServerStatus? = nil
    private var fetchHash: UUID = UUID()
    private var isFetching: Bool = false
    
    func runCheck(with ipAddress: String? = nil, u: String, p: String) async throws {
        guard !isFetching else { return }
        isFetching = true
        
        defer { isFetching = false }
        
        let newFetchHash = UUID()
        fetchHash = newFetchHash
        
        do {
            let status = try await fetchServerStatus(with: ipAddress, u: u, p: p)
            if fetchHash == newFetchHash {
                serverStatus = status
            }
        } catch {
            if fetchHash == newFetchHash {
                serverStatus = ServerStatus(online: false, om_verify: "", type: .openmusic)
            }
            throw error
        }
    }
    
    func getServerStatus() -> ServerStatus? {
        serverStatus
    }
    
    func getFetchHash() -> UUID {
        fetchHash
    }
    
    func getIsFetching() -> Bool {
        isFetching
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class StatusViewModel {
    private let viewActor = StatusViewActor()
    
    var serverStatus: ServerStatus? = nil
    private var tempIPAddress: String? = ""
    var finalIPAddress: String = ""
    var fetchHash: UUID = UUID()
    var activeFetchingTask: Task<Void, Never>? = nil
    
    // alternative server
    var askForCreds: Bool = false
    var username: String = ""
    var password: String = ""
    
    func clearPastChecks() {
        activeFetchingTask?.cancel()
        serverStatus = nil
        askForCreds = false
    }
    
    func runCheck(with ipAddress: String? = nil, isExhaustive: Bool = false) {
        clearPastChecks()
        tempIPAddress = ipAddress
        if isExhaustive, let ipAddress = ipAddress {
            tempIPAddress = "https://\(ipAddress)"
        }
        activeFetchingTask = Task {
            try? await viewActor.runCheck(with: tempIPAddress, u: username, p: password)
            if isExhaustive {
                if await !(viewActor.getServerStatus()?.online ?? false) {
                    updateTempIPAddress(with: "\(ipAddress ?? "")")
                    try? await viewActor.runCheck(with: tempIPAddress, u: username, p: password)
                }
                if await !(viewActor.getServerStatus()?.online ?? false) {
                    updateTempIPAddress(with: "http://\(ipAddress ?? "")")
                    try? await viewActor.runCheck(with: tempIPAddress, u: username, p: password)
                }
            }
            updateIPCreds(status: await viewActor.getServerStatus(), hash: await viewActor.getFetchHash())
        }
    }
    
    @MainActor
    func updateTempIPAddress(with: String) {
        tempIPAddress = with
    }
    
    @MainActor
    func updateIPCreds(status: ServerStatus?, hash: UUID) {
        withAnimation {
            serverStatus = status
            if tempIPAddress == "http://" {
                finalIPAddress = ""
            } else {
                finalIPAddress = tempIPAddress ?? ""
            }
            fetchHash = hash
        }
    }
}

struct ServerStatus: Codable, Hashable {
    var online: Bool
    var title: String
    var body: String
    var footer: String
    var om_verify: String
    var type: ServerType
    
    init(online: Bool, om_verify: String, type: ServerType) {
        self.online = online
        self.title = ""
        self.body = ""
        self.footer = ""
        self.om_verify = om_verify
        self.type = type
    }
    
    init(online: Bool, title: String, body: String, footer: String, om_verify: String, type: ServerType) {
        self.online = online
        self.title = title
        self.body = body
        self.footer = footer
        self.om_verify = om_verify
        self.type = type
    }
    
    private enum CodingKeys: String, CodingKey {
        case online, title, body, footer, om_verify, type
    }
}
