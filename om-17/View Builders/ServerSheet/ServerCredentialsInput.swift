//
//  ServerCredentialsInput.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import SwiftUI

struct ServerCredentialsInput: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var inputIPAddress: String
    @Binding var viewModel: StatusViewModel
    var body: some View {
        VStack {
            Divider()
            TextField("Username...", text: $viewModel.username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.leading)
            Divider()
            SecureField("Password...", text: $viewModel.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.leading)
            HStack {
                Spacer()
                Button(action: {
                    self.viewModel.runCheck(with: inputIPAddress, isExhaustive: true)
                }) {
                    Text(viewModel.serverStatus?.om_verify == "bad" ? "Login" : "Logged In")
                        .foregroundStyle(.blue)
                        .customFont(fontManager, .body .bold())
                        .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Spacer()
            }
        }
    }
}

