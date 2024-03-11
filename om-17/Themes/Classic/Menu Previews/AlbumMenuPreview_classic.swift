//
//  AlbumMenuPreview_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct AlbumMenuPreview_classic: View {
    var album: Album
    @State var realURL: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: self.realURL, Resolution: .tile, Blur: 20, BlurOpacity: 0.3, cornerRadius: 8.0)
                .frame(width: 200, height: 200)
                .fixedSize()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.realURL = album.Artwork
                    }
                }
            VStack(alignment: .leading) {
                Text(album.Title)
                    .customFont(.title3, bold: true)
                    .foregroundStyle(.primary)
                    .lineLimit(8)
                Text(stringArtists(artistlist: album.Artists))
                    .customFont(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                Text("\(album.AlbumType) • \(album.Year.codingKey.stringValue)")
                    .customFont(.subheadline)
                    .foregroundStyle(.tertiary)
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
            AlbumMenuPreview_classic(album: SearchedAlbum(default: true))
        }
    
}

#Preview {
    AlbumMenuPreview_classic(album: SearchedAlbum(default: true))
}
