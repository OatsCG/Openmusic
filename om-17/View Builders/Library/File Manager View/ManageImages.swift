//
//  ManageImages.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI

struct ManageImages: View {
    @Environment(DownloadManager.self) var downloadManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        List {
            ForEach(downloadManager.gather_downloaded_images(), id: \.hashValue) { track in
                HStack {
                    BetterAsyncImage(url: RetrieveArtwork(url: track.Title), animated: false)
                        .frame(width: 80, height: 80)
                        .cornerRadius(5)
                    VStack(alignment: .leading) {
                        Text(track.Title)
                        Text(track.TrackID)
                            .foregroundStyle(.secondary)
                            .customFont(fontManager, .footnote)
                    }
                        .multilineTextAlignment(.leading)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        downloadManager.delete_image(url: track.Title)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                    }
                        .tint(.red)
                }
            }
        }
            .safeAreaPadding(.bottom, 80)
            .scrollContentBackground(.hidden)
            .background {
                GlobalBackground_component()
            }
    }
}

#Preview {
    ManageImages()
}
