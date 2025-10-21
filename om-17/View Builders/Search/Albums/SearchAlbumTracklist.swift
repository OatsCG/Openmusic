//
//  Tracklist.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-08.
//

import SwiftUI
import SwiftData

struct SearchAlbumTracklist: View {
    @Binding var albumModel: AlbumViewModel
    
    var body: some View {
        ForEach(Array(tracks().enumerated()), id: \.offset) {index, track in
            SearchAlbumSongLink(track: track, continuation: self.continuations(index: index), min: min_views(), max: max_views())
            Divider()
        }
    }
    
    func tracks() -> [FetchedTrack] {
        return albumModel.fetchedAlbum?.Tracks ?? []
    }
    
    func continuations(index: Int) -> [FetchedTrack] {
        return Array(tracks().suffix(from: index))
    }
    
    func min_views() -> Int? {
        return tracks().min(by: { $0.Views < $1.Views })?.Views
    }
    
    func max_views() -> Int? {
        return tracks().max(by: { $0.Views < $1.Views })?.Views
    }
}

#Preview {
    SearchAlbumContent(album: SearchedAlbum())
}
