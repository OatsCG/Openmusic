//
//  AlbumContentButtons_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_faero: View {
    @Environment(NetworkMonitor.self) var networkMonitor
    var text: String
    var subtitle: String?
    var ArtworkID: String
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(text)
                if (!networkMonitor.isConnected && subtitle != nil) {
                    Text(subtitle!)
                        .customFont(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
            .customFont(.body)
            .padding(10)
            .background {
                AeroGlossBG(cornerRadius: 10)
                    .opacity(0.6)
                .overlay {
                    AeroGlossOverlay(baseCornerRadius: 10, padding: 0)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
            //.border(.red)
    }
}

#Preview {
    Button(action: {}) {
        AlbumWideButton_faero(text: "Play", ArtworkID: SearchedAlbum(default: true).Artwork)
    }
        .buttonStyle(.plain)
        .environment(NetworkMonitor())
}
