//
//  AddServerSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-21.
//

import SwiftUI

struct AddServerSheet: View {
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @Binding var showingServerSheet: Bool
    @State var viewModel: StatusViewModel = StatusViewModel()
    var body: some View {
        ScrollView {
            
            VStack(spacing: 10) {
                Text("Input your Server URL Here.")
                    .customFont(.title2, bold: true)
                    .padding(.top, 50)
                Text("For help with servers check out\n**[openmusic.app](https://openmusic.app)**,")
                    .customFont(.subheadline)
                    .padding(.bottom, 5)
                VStack(spacing: 3) {
                    Text("or add the demo server")
                        .customFont(.subheadline)
                    Button(action: {
                        globalIPAddress = "https://server.openmusic.app"
                    }) {
                        Text(verbatim: "https://server.openmusic.app")
                            .customFont(.subheadline, bold: true)
                            //.foregroundStyle(.secondary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.indigo.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                    }
                    .buttonStyle(.plain)
                }
                    .padding(.bottom, 20)
                VStack {
                    HStack {
                        TextField("Server URL...", text: $globalIPAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .multilineTextAlignment(.leading)
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
                    VStack {
                        if (viewModel.serverStatus?.online ?? false) {
                            if (
                                ((viewModel.serverStatus?.title ?? "") != "") ||
                                ((viewModel.serverStatus?.body ?? "") != "") ||
                                ((viewModel.serverStatus?.footer ?? "") != "")) {
                                Divider()
                                HStack {
                                    Text("From: \(globalIPAddress)/status")
                                        .customFont(.caption)
                                        .foregroundStyle(.quaternary)
                                    Spacer()
                                }
                                .padding(.bottom, 5)
                            }
                            VStack {
                                if ((viewModel.serverStatus?.title ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.title ?? "")
                                            .customFont(.subheadline, bold: true)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                }
                                if ((viewModel.serverStatus?.body ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.body ?? "")
                                            .customFont(.caption)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                }
                                if ((viewModel.serverStatus?.footer ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.footer ?? "")
                                            .customFont(.footnote)
                                            .foregroundStyle(.tertiary)
                                        Spacer()
                                    }
                                }
                            }
                                .lineLimit(20)
                        }
                    }
                        //.padding([.horizontal], 30)
                        .multilineTextAlignment(.leading)
                }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Button(action: {
                    showingServerSheet = false
                }) {
                    HStack {
                        Text("Add Server")
                        Image(systemName: "network")
                    }
                    .foregroundStyle((viewModel.serverStatus?.online ?? false) ? ((viewModel.serverStatus!.om_verify == "topsecretpassword") ? .cyan : .green) : .gray)
                        .customFont(.title3)
                        .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                Text("You can change the server later in Options.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
            .safeAreaPadding(.all, 20)
            .multilineTextAlignment(.center)
    }
}


#Preview {
    AddServerSheet(showingServerSheet: .constant(true))
}
