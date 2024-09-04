//
//  dltest.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-08.
//

import SwiftUI

struct PlaybackExplicityDownloadedIcon: View {
    @Environment(DownloadManager.self) var downloadManager
    @Environment(PlayerManager.self) var playerManager
    var track: any Track
    var explicit: Bool = false
    var isDownloaded: Bool? = nil
    @State var isFoundDownloaded: Bool = false
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    if (track.Playback_Explicit != nil && track.Playback_Clean != nil) {
                        Image(systemName: "square")
                            .offset(x: -4, y: -4)
                    }
                    Image(systemName: "square.fill")
                }
                    .compositingGroup()
                    .opacity(0.24)
                Image(systemName: explicit ? "e.square" : "c.square")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary, .clear)
            }
            if let isDownloaded = isDownloaded, isDownloaded == true {
                Image(systemName: "chevron.compact.down")
                    .foregroundStyle(.tertiary)
            } else if isFoundDownloaded {
                Image(systemName: "chevron.compact.down")
                    .foregroundStyle(.tertiary)
            }
        }
            .padding([.top, .leading], (track.Playback_Explicit != nil && track.Playback_Clean != nil) ? 4 : 0)
            .onAppear {
                Task {
                    await findDownload()
                }
            }
    }
    
    func findDownload() async {
        self.isFoundDownloaded = await downloadManager.is_downloaded(track, explicit: explicit)
    }
}

#Preview {
    VStack {
        PlaybackExplicityDownloadedIcon(track: FetchedTrack(), explicit: true)
        //PlaybackExplicityDownloadedIcon(track: FetchedTrack_default(), explicit: false)
    }
}
