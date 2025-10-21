//
//  AddServerButton.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import SwiftUI

struct AddServerButton: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var showingServerSheet: Bool
    @Binding var viewModel: StatusViewModel
    
    var body: some View {
        Button(action: {
            NetworkManager.shared.updateGlobalIPAddress(with: viewModel.finalIPAddress, type: viewModel.serverStatus?.type ?? .openmusic, u: viewModel.username, p: viewModel.password)
            showingServerSheet = false
        }) {
            HStack {
                Text("Add Server")
                Image(systemName: "network")
            }
            .foregroundStyle((viewModel.serverStatus?.online ?? false) ? ((viewModel.serverStatus?.om_verify == "topsecretpassword") ? .cyan : .green) : .gray)
                .customFont(fontManager, .title3)
                .padding(EdgeInsets(top: 6, leading: 26, bottom: 6, trailing: 26))
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
            .buttonStyle(.plain)
            .padding(.top, 10)
    }
}
