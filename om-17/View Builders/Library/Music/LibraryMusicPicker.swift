//
//  LibraryMusicPicker.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct LibraryMusicPicker: View {
    @State var selectedPickMusic: MusicPicks = .albums
    @Binding var tracks: [StoredTrack]
    @State var albumSortType: LibrarySortType = .date_up
    @State var songSortType: LibrarySortType = .date_up
    @State var artistSortType: LibrarySortType = .date_up
    @State var filterDownloaded: Bool = false
    var body: some View {
        VStack {
            HStack {
                Picker("Music", selection: $selectedPickMusic) {
                    ForEach(MusicPicks.allCases) { option in
                        Label(option.rawValue.capitalized, systemImage: musicPickSymbol(pick: option))
                    }
                }
                Spacer()
                FilterMenu(selectedPickMusic: $selectedPickMusic, albumSortType: $albumSortType, songSortType: $songSortType, artistSortType: $artistSortType, filterDownloaded: $filterDownloaded)
            }
            switch selectedPickMusic {
            case .albums:
                LibraryAlbumsList(tracks: $tracks, sortType: $albumSortType, filterOnlyDownloaded: $filterDownloaded)
            case .artists:
                LibraryArtistsList(tracks: $tracks, sortType: $artistSortType, filterOnlyDownloaded: $filterDownloaded)
            case .songs:
                LibrarySongsList(tracks: $tracks, sortType: $songSortType, filterOnlyDownloaded: $filterDownloaded)
            }
        }
    }
}

#Preview {
    LibraryMusicPicker(tracks: .constant([]))
}
