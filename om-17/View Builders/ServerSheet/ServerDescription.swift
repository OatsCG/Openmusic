//
//  ServerDescription.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import SwiftUI

struct ServerDescription: View {
    @Environment(FontManager.self) private var fontManager
    @Binding var viewModel: StatusViewModel
    
    var body: some View {
        VStack {
            if viewModel.serverStatus?.online ?? false {
                if (
                    ((viewModel.serverStatus?.title ?? "") != "") ||
                    ((viewModel.serverStatus?.body ?? "") != "") ||
                    ((viewModel.serverStatus?.footer ?? "") != "")) {
                    Divider()
                    HStack {
                        Text("From: \(viewModel.finalIPAddress)/status")
                            .customFont(fontManager, .caption)
                            .foregroundStyle(.quaternary)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                VStack {
                    if (viewModel.serverStatus?.title ?? "") != "" {
                        HStack {
                            Text(viewModel.serverStatus?.title ?? "")
                                .customFont(fontManager, .subheadline, bold: true)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    if (viewModel.serverStatus?.body ?? "") != "" {
                        HStack {
                            Text(viewModel.serverStatus?.body ?? "")
                                .customFont(fontManager, .caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    if (viewModel.serverStatus?.footer ?? "") != "" {
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
            .multilineTextAlignment(.leading)
    }
}
