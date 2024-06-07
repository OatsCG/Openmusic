//
//  AddServerSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-21.
//

import SwiftUI

struct AddServerSheet: View {
    @Environment(FontManager.self) private var fontManager
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @Binding var showingServerSheet: Bool
    @State var tempIPAddress: String = ""
    @State var viewModel: StatusViewModel = StatusViewModel()
    var body: some View {
        ScrollView {
            
            VStack(spacing: 10) {
                Text("Input your Server URL Here.")
                    .customFont(fontManager, .title2, bold: true)
                    .padding(.top, 50)
                Text("For help with servers, visit\n**[create.openmusic.app](https://create.openmusic.app)**")
                    .customFont(fontManager, .subheadline)
                    .padding(.bottom, 5)
                VStack {
                    HStack {
                        TextField("Server URL...", text: $tempIPAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .multilineTextAlignment(.leading)
                            .onChange(of: tempIPAddress) {
                                //updateGlobalIPAddress(with: globalIPAddress)
                                self.viewModel.runCheck(with: tempIPAddress)
                            }
                            .onAppear {
                                self.viewModel.runCheck(with: tempIPAddress)
                            }
                        Divider()
                        Button(action: {self.viewModel.runCheck(with: tempIPAddress)}) {
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
                    VStack {
                        if (viewModel.serverStatus?.online ?? false) {
                            if (
                                ((viewModel.serverStatus?.title ?? "") != "") ||
                                ((viewModel.serverStatus?.body ?? "") != "") ||
                                ((viewModel.serverStatus?.footer ?? "") != "")) {
                                Divider()
                                HStack {
                                    Text("From: \(tempIPAddress)/status")
                                        .customFont(fontManager, .caption)
                                        .foregroundStyle(.quaternary)
                                    Spacer()
                                }
                                .padding(.bottom, 5)
                            }
                            VStack {
                                if ((viewModel.serverStatus?.title ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.title ?? "")
                                            .customFont(fontManager, .subheadline, bold: true)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                }
                                if ((viewModel.serverStatus?.body ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.body ?? "")
                                            .customFont(fontManager, .caption)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                }
                                if ((viewModel.serverStatus?.footer ?? "") != "") {
                                    HStack {
                                        Text(viewModel.serverStatus?.footer ?? "")
                                            .customFont(fontManager, .footnote)
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
                if viewModel.serverStatus?.online == true {
                    Text("By clicking **Add Server**, you are stating that the server “\(tempIPAddress)” and all of its content (audio files, images, titles, etc) are owned by you.\n\nYou are also giving permission for the Openmusic app to display and play your content, as well as to use your server’s endpoints for suggestions and discovery features.")
                }
                Button(action: {
                    updateGlobalIPAddress(with: tempIPAddress)
                    showingServerSheet = false
                }) {
                    HStack {
                        Text("Add Server")
                        Image(systemName: "network")
                    }
                    .foregroundStyle((viewModel.serverStatus?.online ?? false) ? ((viewModel.serverStatus!.om_verify == "topsecretpassword") ? .cyan : .green) : .gray)
                        .customFont(fontManager, .title3)
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
