//
//  NetworkMonitor.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-02.
//

import SwiftUI
import Network

@MainActor
@Observable final class NetworkMonitor {
    static let shared = NetworkMonitor()
    let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = true
    var currentPath: NetworkType = .none

    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                withAnimation {
                    self.isConnected = path.status == .satisfied
                    if path.usesInterfaceType(.wifi) {
                        self.currentPath = .wifi
                    } else if path.usesInterfaceType(.cellular) {
                        self.currentPath = .cellular
                    } else if path.status == .unsatisfied {
                        self.currentPath = .none
                    }
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}

enum NetworkType {
    case wifi, cellular, none
}
