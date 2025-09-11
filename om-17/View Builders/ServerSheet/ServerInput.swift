//
//  ServerInput.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import SwiftUI

struct ServerInput: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var inputIPAddress: String
    @Binding var viewModel: StatusViewModel
    var body: some View {
        VStack {
            HStack {
                TextField("Server URL...", text: $inputIPAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .multilineTextAlignment(.leading)
                    .onChange(of: inputIPAddress) {
                        self.viewModel.runCheck(with: inputIPAddress, isExhaustive: true)
                    }
                    .onAppear {
                        self.viewModel.runCheck(with: inputIPAddress, isExhaustive: true)
                    }
                Divider()
                ServerStatusIndicator(inputIPAddress: $inputIPAddress, viewModel: $viewModel)
            }
            if viewModel.serverStatus?.type == .navidrome {
                ServerCredentialsInput(inputIPAddress: $inputIPAddress, viewModel: $viewModel)
            }
        }
    }
}

