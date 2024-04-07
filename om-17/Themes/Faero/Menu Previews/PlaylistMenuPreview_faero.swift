//
//  PlaylistMenuPreview_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-31.
//

import SwiftUI

struct PlaylistMenuPreview_faero: View {
    @Environment(FontManager.self) private var fontManager
    var playlist: Playlist
    @State var realURL: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            PlaylistArtDisplay(playlist: playlist, Blur: 20, BlurOpacity: 0.3, cornerRadius: 8.0)
                .frame(width: 200, height: 200)
                .fixedSize()
                .frame(width: 200, height: 200)
            VStack(alignment: .leading) {
                Text(playlist.Title)
                    .customFont(fontManager, .title3, bold: true)
                    .foregroundStyle(.primary)
                    .lineLimit(8)
                Text("\(playlist.items.count) Songs")
                    .customFont(fontManager, .callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
            }
        }
            .multilineTextAlignment(.leading)
            .frame(width: 200)
            .padding(10)
    }
}

#Preview {
    Text("Press to Reveal")
        .contextMenu {
            Button(action: {}) {
                Text("Button")
            }
        } preview: {
            PlaylistMenuPreview_faero(playlist: SearchedPlaylist(Title: "test"))
        }
    
}
