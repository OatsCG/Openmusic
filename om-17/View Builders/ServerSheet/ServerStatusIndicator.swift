//
//  ServerStatusIndicator.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import SwiftUI

struct ServerStatusIndicator: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var inputIPAddress: String
    @Binding var viewModel: StatusViewModel
    var body: some View {
        Button(action: {self.viewModel.runCheck(with: inputIPAddress, isExhaustive: true)}) {
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
