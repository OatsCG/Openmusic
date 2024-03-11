//
//  StoredPlayback.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-12.
//

import Foundation
import SwiftData

@Observable class DownloadData: Identifiable {
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
        self.parent = track
        self.playbackID = explicit ? track.Playback_Explicit! : track.Playback_Clean!
        self.explicit = explicit
    }
    
    static func == (lhs: DownloadData, rhs: DownloadData) -> Bool {
        return (lhs.parent.TrackID == rhs.parent.TrackID && lhs.explicit == rhs.explicit)
    }
}
