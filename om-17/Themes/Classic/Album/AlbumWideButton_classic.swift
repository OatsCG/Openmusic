//
//  AlbumContentButtons_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_classic: View {
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
                AlbumBackground(ArtworkID: ArtworkID, blur: 50, light_opacity: 0.15, dark_opacity: 0.3, spin: false, saturate: true)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
            //.border(.red)
    }
}

#Preview {
    Button(action: {}) {
        AlbumWideButton_classic(text: "Play", ArtworkID: SearchedAlbum(default: true).Artwork)
    }
        .buttonStyle(.plain)
        .environment(NetworkMonitor())
}
