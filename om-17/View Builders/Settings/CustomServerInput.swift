//
//  CustomServerInput.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-26.
//

import SwiftUI

struct CustomServerInput: View {
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @State var viewModel: StatusViewModel = StatusViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Server URL...", text: $globalIPAddress)
                    //.disabled(true)
                    //.foregroundStyle(.secondary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .onChange(of: globalIPAddress) {
                        updateGlobalIPAddress(with: globalIPAddress)
                        self.viewModel.runCheck()
                    }
                    .onAppear {
                        self.viewModel.runCheck()
                    }
                Divider()
                Button(action: {self.viewModel.runCheck()}) {
                    HStack {
                        if (viewModel.serverStatus == nil) {
                            Image(systemName: "circle.fill")
                                .customFont(.caption2)
                                .foregroundStyle(.gray)
                            Text("Fetching")
                        } else {
                            if (viewModel.serverStatus!.online) {
                                if (viewModel.serverStatus!.om_verify == "topsecretpassword") {
                                    Image(systemName: "circle.fill")
                                        .customFont(.caption2)
                                        .foregroundStyle(.cyan)
                                    VStack {
                                        Text("Verified")
                                    }
                                } else {
                                    Image(systemName: "circle.fill")
                                        .customFont(.caption2)
                                        .foregroundStyle(.green)
                                    Text("Online")
                                }
                            } else {
                                Image(systemName: "circle.fill")
                                    .customFont(.caption2)
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
//            Group {
//                if (viewModel.serverStatus?.online ?? false) {
//                    if (
//                        ((viewModel.serverStatus?.title ?? "") != "") ||
//                        ((viewModel.serverStatus?.body ?? "") != "") ||
//                        ((viewModel.serverStatus?.footer ?? "") != "")) {
//                        Divider()
//                    }
//                    VStack {
//                        if ((viewModel.serverStatus?.title ?? "") != "") {
//                            HStack {
//                                Text(viewModel.serverStatus?.title ?? "")
//                                    .customFont(.subheadline, bold: true)
//                                    .foregroundStyle(.secondary)
//                                Spacer()
//                            }
//                        }
//                        if ((viewModel.serverStatus?.body ?? "") != "") {
//                            HStack {
//                                Text(viewModel.serverStatus?.body ?? "")
//                                    .customFont(.caption)
//                                    .foregroundStyle(.secondary)
//                                Spacer()
//                            }
//                        }
//                        if ((viewModel.serverStatus?.footer ?? "") != "") {
//                            HStack {
//                                Text(viewModel.serverStatus?.footer ?? "")
//                                    .customFont(.footnote)
//                                    .foregroundStyle(.tertiary)
//                                Spacer()
//                            }
//                        }
//                    }
//                        .lineLimit(1)
//                }
//            }
        }
    }
}

#Preview {
    SettingsPage()
        .environment(PlayerManager())
        .environment(DownloadManager())
}
