//
//  ManageAudios.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI
import AVFoundation


struct ManageAudios: View {
    @Environment(DownloadManager.self) var downloadManager
    var body: some View {
        List {
            ForEach(downloadManager.gather_downloaded_audios(), id: \.hashValue) { track in
                AudioFileRow(track: track)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            downloadManager.delete_playback(url: track.Title)
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
    ManageAudios()
}
