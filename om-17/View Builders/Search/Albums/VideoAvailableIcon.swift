//
//  VideoAvailableIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import SwiftUI
import SwiftData

struct VideoAvailableIcon: View {
    var track: FetchedTrack
    var body: some View {
        HStack {
            if (track.Playback_Clean != nil) {
                Image(systemName: "c.square")
            }
        }
    }
}

