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
                        Spacer()
                    }
                    .background {
                        Rectangle()
                    }
                    ScrollView {
                        NetworkLogView(networkLog: NetworkLog(requestURL: "test"))
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red)
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
            Divider()
            Text(networkLog.requestURL)
            Spacer()
            Divider()
            Text(networkLog.responseStatus.rawValue)
        }
        .background {
            Rectangle().fill(.clear).stroke(.white)
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
