//
//  StatusFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-26.
//

import Foundation
import SwiftUI

// Function to fetch server status
func fetchServerStatus(with tempIPAddress: String? = nil) async throws -> ServerStatus {
    var urlString = NetworkManager.shared.networkService.getEndpointURL(.status)
    if let tempIPAddress = tempIPAddress {
        urlString = "\(tempIPAddress)/status"
    }
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(ServerStatus.self, from: data)
}

// Actor to manage server status data
actor StatusViewActor {
    private var serverStatus: ServerStatus? = nil
    private var fetchHash: UUID = UUID()
    private var isFetching: Bool = false
    
    func runCheck(with ipAddress: String? = nil) async throws {
        guard !isFetching else { return }
        isFetching = true
        
        defer { isFetching = false }
        
        let newFetchHash = UUID()
        self.fetchHash = newFetchHash
        
        do {
            let status = try await fetchServerStatus(with: ipAddress)
            if self.fetchHash == newFetchHash {
                self.serverStatus = status
            }
        } catch {
            if self.fetchHash == newFetchHash {
                self.serverStatus = ServerStatus(online: false, om_verify: "", type: .openmusic)
            }
            throw error
        }
    }
    
    func getServerStatus() -> ServerStatus? {
        return serverStatus
    }
    
    func getFetchHash() -> UUID {
        return fetchHash
    }
    
    func getIsFetching() -> Bool {
        return isFetching
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
    
    // navidrome
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
            try? await viewActor.runCheck(with: tempIPAddress)
            if isExhaustive {
                if await !(viewActor.getServerStatus()?.online ?? false) {
                    await MainActor.run {
                        tempIPAddress = "\(ipAddress ?? "")"
                    }
                    try? await viewActor.runCheck(with: tempIPAddress)
                }
                if await !(viewActor.getServerStatus()?.online ?? false) {
                    updateTempIPAddress(with: "http://\(ipAddress ?? "")")
                    try? await viewActor.runCheck(with: tempIPAddress)
                }
            }
            let status = await viewActor.getServerStatus()
            let currentHash = await viewActor.getFetchHash()
            
            updateIPCreds(status: status, hash: currentHash)
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
    
    private enum CodingKeys: String, CodingKey {
        case online, title, body, footer, om_verify, type
    }
}
