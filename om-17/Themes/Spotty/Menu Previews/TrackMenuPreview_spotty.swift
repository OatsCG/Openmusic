//
//  TrackMenuPreview_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct TrackMenuPreview_spotty: View {
    @Environment(FontManager.self) private var fontManager
    var track: any Track
    @State var realURL: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            AlbumArtDisplay(ArtworkID: self.realURL, Resolution: .tile, Blur: 20, BlurOpacity: 0.3, cornerRadius: 8.0)
                .frame(width: 200, height: 200)
                .fixedSize()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.realURL = track.Album.Artwork
                    }
                }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(track.Album.Title)
                        .customFont(fontManager, .caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                    Text(stringArtists(artistlist: track.Album.Artists))
                        .customFont(fontManager, .caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(3)
                }
                Spacer()
                HStack(spacing: 0) {
                    if (track.Playback_Clean != nil) {
                        Image(systemName: "c.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    if (track.Playback_Explicit != nil) {
                        Image(systemName: "e.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.bottom, 3)
            Text(track.Title)
                .customFont(fontManager, .headline, bold: true)
                .foregroundStyle(.primary)
                .lineLimit(4)
            if (track.Features.count != 0) {
                Text(stringArtists(artistlist: track.Features))
                    .customFont(fontManager, .callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
            }
            Text(secondsToText(seconds: track.Length))
                .customFont(fontManager, .subheadline)
                .foregroundStyle(.tertiary)
                .lineLimit(1)
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
            TrackMenuPreview_spotty(track: FetchedTrack(default: true))
        }
    
}
