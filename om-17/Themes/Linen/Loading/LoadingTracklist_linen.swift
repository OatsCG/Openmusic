//
//  LoadingTracklist_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct LoadingTracklist_linen: View {
    var body: some View {
        ForEach(1...20, id: \.self) {track in
            LoadingAlbumTrack_linen()
            Divider()
        }
    }
}

#Preview {
    ScrollView {
        LoadingTracklist_linen()
    }
}
