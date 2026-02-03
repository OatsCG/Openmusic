//
//  BrowseEmptyPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-02-03.
//

import SwiftUI

struct BrowseEmptyPage: View {
    @Environment(NetworkMonitor.self) var networkMonitor
    var body: some View {
        if NetworkManager.globalIPAddress() == "" {
            NoServerAddedComponent(showingServerSheet: .constant(false))
        } else if !networkMonitor.isConnected {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ContentUnavailableView {
                        Label("No Connection", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text("Check your server connection in Options.")
                    }
                    Spacer()
                }
                Spacer()
            }
        } else {
            ProgressView()
        }
    }
}
