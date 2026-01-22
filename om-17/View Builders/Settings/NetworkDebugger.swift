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
                Toggle("Show Log Notifications", isOn: $networkDebuggerEnabled)
                    .tint(.green)
            } footer: {
                Text("Receive toasts for network requests. Logs are reset on app restart.")
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
        HStack {
            Text(networkLog.time.formatted(date: .omitted, time: .shortened))
                .foregroundStyle(.white)
            Divider()
            Text(networkLog.requestURL)
                .foregroundStyle(.white)
            Spacer()
            Divider()
            Text(networkLog.responseStatus.rawValue)
                .foregroundStyle(networkLog.responseStatus == .pending ? Color.gray : (networkLog.responseStatus == .failed ? Color.red : Color.white))
        }
        .padding(5)
        .background {
            Rectangle().fill(.clear).stroke(.white.opacity(0.4))
        }
    }
}

class NetworkLog {
    var id: UUID
    var time: Date
    var requestURL: String
    var responseStatus: ResponseStatus
    var responseObject: Codable?
    
    init(requestURL: String) {
        self.id = UUID()
        self.time = Date()
        self.requestURL = requestURL
        self.responseStatus = .pending
        self.responseObject = nil
    }
}

enum ResponseStatus: String {
    case pending, failed, success
}

#Preview {
    NetworkDebugger()
}
