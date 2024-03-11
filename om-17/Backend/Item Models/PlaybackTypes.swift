//
//  PlaybackTypes.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-16.
//

import SwiftUI

struct FetchedPlayback: Codable, Hashable {
    var PlaybackID: String
    var YT_Video_ID: String?
    var YT_Audio_ID: String
    var Playback_Audio_URL: String
}
