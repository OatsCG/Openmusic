//
//  LiveDownloadRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-16.
//

import SwiftUI

struct LiveDownloadRow: View {
    var download: DownloadData
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: download.parent.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 4)
            VStack(alignment: .leading) {
                HStack {
                    Text(download.parent.Title)
                        .customFont(.callout)
                }
                HStack {
                    Text(stringArtists(artistlist: download.parent.Album.Artists))
                        .customFont(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: download.explicit ? "e.square" : "c.square")
                .symbolRenderingMode(.hierarchical)
                .task {
                    print("\(download.parent.Title): \(download.state)")
                }
            LiveDownloadStatus(download: download)
                
        }
            //.aspectRatio(8 / 1, contentMode: .fit)
            .frame(height: 51)
            .listRowBackground(Color.clear)
    }
}


struct CircularProgressView: View {
    var progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.secondary.opacity(0.25),
                    lineWidth: 4
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 25, height: 25)
        .padding(5)
    }
}
