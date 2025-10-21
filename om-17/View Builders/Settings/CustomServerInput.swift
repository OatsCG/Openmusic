//
//  CustomServerInput.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-26.
//

import SwiftUI

struct CustomServerInput: View {
    @Environment(FontManager.self) private var fontManager
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @State var viewModel: StatusViewModel = StatusViewModel()
    @State var showingServerSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("No URL Entered", text: $globalIPAddress)
                    .disabled(true)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .onAppear {
                        viewModel.runCheck()
                    }
                Divider()
                Button(action: { showingServerSheet = true }) {
                    Text("Edit")
                        .foregroundStyle(.primary)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(.quinary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showingServerSheet, content: {
                        AddServerSheet(showingServerSheet: $showingServerSheet)
                    })
                Divider()
                Button(action: {viewModel.runCheck()}) {
                    HStack {
                        if let serverStatus = viewModel.serverStatus {
                            if serverStatus.online {
                                if (serverStatus.om_verify == "topsecretpassword") {
                                    Image(systemName: "circle.fill")
                                        .customFont(fontManager, .caption2)
                                        .foregroundStyle(.cyan)
                                    VStack {
                                        Text("Verified")
                                    }
                                } else {
                                    Image(systemName: "circle.fill")
                                        .customFont(fontManager, .caption2)
                                        .foregroundStyle(.green)
                                    Text("Online")
                                }
                            } else {
                                Image(systemName: "circle.fill")
                                    .customFont(fontManager, .caption2)
                                    .foregroundStyle(.red)
                                Text("Offline")
                            }
                        } else {
                            Image(systemName: "circle.fill")
                                .customFont(fontManager, .caption2)
                                .foregroundStyle(.gray)
                            Text("Fetching")
                        }
                    }
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(.quinary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                    .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    SettingsPage()
        .environment(PlayerManager())
        .environment(DownloadManager())
}
