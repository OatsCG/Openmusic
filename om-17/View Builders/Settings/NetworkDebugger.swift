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
        VStack {
            Button(action: {
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("time: ")
                    Text(networkLog.time.description)
                }
            }
            Divider()
            Button(action: {
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("requestURL: ")
                    Text(networkLog.requestURL)
                }
            }
            Divider()
            Button(action: {
                ToastManager.shared.propose(toast: Toast(artworkID: nil, message: "Copied to Clipboard", .saved))
            }) {
                HStack {
                    Text("responseStatus: ")
                    Text(networkLog.responseStatus.rawValue)
                }
            }
            Divider()
            Button(action: {
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
    case .search(q: let q):
        "search"
    case .quick(q: let q):
        "quick"
    case .album(id: let id):
        "album"
    case .artist(id: let id):
        "artist"
    case .random:
        "random"
    case .playlistinfo(platform: let platform, id: let id):
        "playlistinfo"
    case .ampVideo(id: let id):
        "ampVideo"
    case .playlisttracks(platform: let platform, id: let id):
        "playlisttracks"
    case .exact(song: let song, album: let album, artist: let artist):
        "exact"
    case .suggest(songs: let songs):
        "suggest"
    case .suggestVibe(genre: let genre, acousticness: let acousticness, danceability: let danceability, energy: let energy, instrumentalness: let instrumentalness, liveness: let liveness, mode: let mode, speechiness: let speechiness, valence: let valence):
        "suggestVibe"
    case .playback(id: let id):
        "playback"
    case .image(id: let id, w: let w, h: let h):
        "image"
    }
}

enum ResponseStatus: String {
    case pending, failed, success
}

#Preview {
    NetworkDebugger()
}
