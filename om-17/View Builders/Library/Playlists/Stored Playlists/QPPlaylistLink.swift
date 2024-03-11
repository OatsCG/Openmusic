//
//  PlaylistQPLink.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct QPPlaylistLink: View {
    var playlist: StoredPlaylist
    var body: some View {
        QPPlaylistLink_component(playlist: playlist)
    }
}
