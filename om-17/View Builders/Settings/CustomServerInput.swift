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
                //Text(globalIPAddress)
                    .disabled(true)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .onAppear {
                        self.viewModel.runCheck()
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
                Button(action: {self.viewModel.runCheck()}) {
                    HStack {
                        if (viewModel.serverStatus == nil) {
                            Image(systemName: "circle.fill")
                                .customFont(fontManager, .caption2)
                                .foregroundStyle(.gray)
                            Text("Fetching")
                        } else {
                            if (viewModel.serverStatus!.online) {
                                if (viewModel.serverStatus!.om_verify == "topsecretpassword") {
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
