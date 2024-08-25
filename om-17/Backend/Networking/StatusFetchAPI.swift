//
//  StatusFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-26.
//

import Foundation
import SwiftUI

func fetchServerStatus(with tempIPAddress: String? = nil, fetchHash: UUID, completion: @escaping @Sendable (Result<ServerStatus, Error>, UUID) -> Void) {
    var url = "\(globalIPAddress())/status"
    if let tempIPAddress = tempIPAddress {
        url = "\(tempIPAddress)/status"
    }
    guard let url = URL(string: url) else {
        print("Invalid URL.")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error), fetchHash)
        } else if let data = data {
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode(ServerStatus.self, from: data)
                completion(.success(fetchedData), fetchHash)
            } catch {
                completion(.failure(error), fetchHash)
            }
        }
    }
    task.resume()
}

@Observable final class StatusViewModel: Sendable {
    var serverStatus: ServerStatus? = nil
    var fetchHash: UUID = UUID()
    func runCheck(with ipAddress: String? = nil) {
        withAnimation() {
            self.serverStatus = nil
            self.fetchHash = UUID()
        }
        fetchServerStatus(with: ipAddress, fetchHash: self.fetchHash) { (result, returnHash) in
            switch result {
            case .success(let data):
                if (self.fetchHash == returnHash) {
                    withAnimation {
                        self.serverStatus = data
                    }
                }
            case .failure(let error):
                if (self.fetchHash == returnHash) {
                    withAnimation {
                        self.serverStatus = ServerStatus(online: false, om_verify: "")
                    }
                }
                print("Error: \(error)")
            }
        }
    }
}


struct ServerStatus: Codable, Hashable {
    var online: Bool
    var title: String
    var body: String
    var footer: String
    var om_verify: String
    
    init(online: Bool, om_verify: String) {
        self.online = online
        self.title = ""
        self.body = ""
        self.footer = ""
        self.om_verify = om_verify
    }
    
    private enum CodingKeys: String, CodingKey {
        case online, title, body, footer, om_verify
    }
}
