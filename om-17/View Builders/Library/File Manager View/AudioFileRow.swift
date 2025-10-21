//
//  AudioFileRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI
import AVFoundation

struct AudioFileRow: View {
    @Environment(FontManager.self) private var fontManager
    @State var tempPlayer: AVAudioPlayer? = nil
    var track: FetchedTrack
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(track.Title)
                Text(track.TrackID)
                    .foregroundStyle(.secondary)
                    .customFont(fontManager, .footnote)
            }
            Spacer()
            Button(action: {
                if tempPlayer?.isPlaying == true {
                    tempPlayer?.stop()
                    tempPlayer = nil
                } else {
                    let trackurl: URL? = URL(string: track.Playback_Clean ?? "")
                    if let trackurl = trackurl {
                        tempPlayer = try? AVAudioPlayer(contentsOf: trackurl)
                        tempPlayer?.play()
                    }
                }
            }) {
                if tempPlayer?.isPlaying == true {
                    Image(systemName: "pause.fill")
                            .font(.headline)
                } else {
                    Image(systemName: "play.fill")
                        .font(.headline)
                }
            }
        }
            .multilineTextAlignment(.leading)
            .onDisappear {
                tempPlayer?.pause()
            }
    }
}
