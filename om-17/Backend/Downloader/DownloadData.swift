//
//  StoredPlayback.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-12.
//

import Foundation
import SwiftData

@Observable final class DownloadData: Identifiable, Sendable {
    let id = UUID()
    var playbackID: String
    var downloadTask: DownloadTask?
    var state: DownloadState = .inactive
    var errorReason: String? = nil
    var date: Date = Date()
    var progress: Double = 0
    var location: URL? = nil
    var size: Int = 0
    var parent: any Track
    let explicit: Bool
    
    init(track: any Track, explicit: Bool) {
        parent = track
        self.explicit = explicit
        if explicit, let Playback_Explicit = track.Playback_Explicit {
            playbackID = Playback_Explicit
        } else {
            playbackID = track.Playback_Clean ?? ""
        }
    }
    
    static func ==(lhs: DownloadData, rhs: DownloadData) -> Bool {
        lhs.parent.TrackID == rhs.parent.TrackID && lhs.explicit == rhs.explicit
    }
}
