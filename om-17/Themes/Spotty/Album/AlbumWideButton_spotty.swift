//
//  AlbumContentButtons_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_spotty: View {
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
                Rectangle().fill(Color(white: 0.24))
            }
            .clipShape(Capsule())
    }
}

#Preview {
    Button(action: {}) {
        AlbumWideButton_spotty(text: "Play", ArtworkID: SearchedAlbum(default: true).Artwork)
    }
        .buttonStyle(.plain)
        .environment(NetworkMonitor())
}
