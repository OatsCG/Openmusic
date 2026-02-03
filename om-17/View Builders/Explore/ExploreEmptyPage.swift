//
//  ExploreEmptyPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-31.
//

import SwiftUI

struct ExploreEmptyPage: View {
    @Environment(NetworkMonitor.self) var networkMonitor
    @Binding var viewModel: ExploreViewModel
    @Binding var vibesViewModel: VibesViewModel
    @Binding var showingServerSheet: Bool
    @Binding var hasFirstLoaded: Bool
    @Binding var exploreType: ExploreType
    var body: some View {
        if viewModel.isSearching {
            LoadingExplore_component()
        } else {
            if NetworkManager.globalIPAddress() == "" {
                NoServerAddedComponent(showingServerSheet: $showingServerSheet)
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
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ContentUnavailableView {
                            Label("No Albums to Display", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text("Check your server and pull to refresh.")
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
