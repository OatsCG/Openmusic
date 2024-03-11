//
//  NetworkMonitor.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-02.
//

import SwiftUI
import Network

@Observable class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = true

    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                withAnimation {
                    self.isConnected = path.status == .satisfied
                }
            }
//            Task {
//                await MainActor.run {
//                    self.objectWillChange.send()
//                }
//            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
