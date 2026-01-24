//
//  NetworkDebugger.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-14.
//

import SwiftUI

struct NetworkDebugger: View {
    @AppStorage("networkDebuggerEnabled") var networkDebuggerEnabled: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Start Logger", isOn: $networkDebuggerEnabled)
                    .tint(.green)
            } footer: {
                Text("Receive toasts for network requests. Logs are deleted when you close the app.")
            }
            
            Section {
                VStack {
                    HStack {
                        Spacer()
                        Text("Network Requests")
                            .font(.body .bold())
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .background {
                        Rectangle().fill(.black)
                    }
                    ScrollView {
                        ForEach(NetworkManager.shared.networkLogs, id: \.id) { log in
                            NetworkLogView(networkLog: log)
                        }
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray)
                        .fill(.black)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Debug")
        .background {
            GlobalBackground_component()
        }
    }
}

struct NetworkLogView: View {
    var networkLog: NetworkLog
    
    var body: some View {
        NavigationLink(destination: NetworkLogDetailView(networkLog: networkLog)) {
            HStack {
                Text(networkLog.time.formatted(date: .omitted, time: .shortened))
                    .foregroundStyle(.white)
                Divider()
                Text(endpointToString(networkLog.endpoint))
                    .foregroundStyle(.white)
                    .monospaced()
                Spacer()
                Divider()
                Text(networkLog.responseStatus.rawValue)
                    .foregroundStyle(networkLog.responseStatus == .pending ? Color.white : (networkLog.responseStatus == .failed ? Color.red : Color.gray))
            }
            .padding(5)
            .background {
                Rectangle().fill(.clear).stroke(.white.opacity(0.4))
            }
        }
    }
}

struct NetworkLogDetailView: View {
    var networkLog: NetworkLog
    
    var body: some View {
        ScrollView {
            Button(action: {
                UIPasteboard.general.string = networkLog.time.description
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("time: ")
                    Text(networkLog.time.description)
                }
            }
            Divider()
            Button(action: {
                UIPasteboard.general.string = networkLog.requestURL
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("requestURL: ")
                    Text(networkLog.requestURL)
                }
            }
            Divider()
            Button(action: {
                UIPasteboard.general.string = networkLog.responseStatus.rawValue
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("responseStatus: ")
                    Text(networkLog.responseStatus.rawValue)
                }
            }
            Divider()
            Button(action: {
                UIPasteboard.general.string = networkLog.responseObject.debugDescription
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("responseObject: ")
                    Text(networkLog.responseObject.debugDescription)
                }
            }
        }
    }
}

class NetworkLog {
    var id: UUID
    var time: Date
    var requestURL: String
    var endpoint: Endpoint
    var responseStatus: ResponseStatus
    var responseObject: Codable?
    
    init(requestURL: String, endpoint: Endpoint) {
        self.id = UUID()
        self.time = Date()
        self.requestURL = requestURL
        self.endpoint = endpoint
        self.responseStatus = .pending
        self.responseObject = nil
    }
}

func endpointToString(_ endpoint: Endpoint) -> String {
    return switch endpoint {
    case .status:
        "status"
    case .explore:
        "explore"
    case .vibes:
        "vibes"
    case .search(q: _):
        "search"
    case .quick(q: _):
        "quick"
    case .album(id: _):
        "album"
    case .artist(id: _):
        "artist"
    case .random:
        "random"
    case .playlistinfo(platform: _, id: _):
        "playlistinfo"
    case .ampVideo(id: _):
        "ampVideo"
    case .playlisttracks(platform: _, id: _):
        "playlisttracks"
    case .exact(song: _, album: _, artist: _):
        "exact"
    case .suggest(songs: _):
        "suggest"
    case .suggestVibe(genre: _, acousticness: _, danceability: _, energy: _, instrumentalness: _, liveness: _, mode: _, speechiness: _, valence: _):
        "suggestVibe"
    case .playback(id: _):
        "playback"
    case .image(id: _, w: _, h: _):
        "image"
    }
}

enum ResponseStatus: String {
    case pending, failed, success
}

#Preview {
    NetworkDebugger()
}
