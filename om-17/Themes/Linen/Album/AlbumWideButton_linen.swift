//
//  AlbumContentButtons_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_linen: View {
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(FontManager.self) var fontManager
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
                        .customFont(fontManager, .caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
            .customFont(fontManager, .body)
            .padding(10)
            .background {
                AlbumBackground(ArtworkID: ArtworkID, blur: 50, light_opacity: 0.05, dark_opacity: 0.3, spin: false, saturate: true)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
            //.border(.red)
    }
}

#Preview {
    Button(action: {}) {
        AlbumWideButton_linen(text: "Play", ArtworkID: SearchedAlbum(default: true).Artwork)
    }
        .buttonStyle(.plain)
        .environment(NetworkMonitor())
}
