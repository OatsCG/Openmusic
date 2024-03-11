//
//  LibraryMusicPicker.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct LibraryMusicPicker: View {
    @State private var selectedPickMusic: MusicPicks = .albums
    var body: some View {
        VStack {
            Picker("Music", selection: $selectedPickMusic) {
                ForEach(MusicPicks.allCases) { option in
                    Label(option.rawValue.capitalized, systemImage: musicPickSymbol(pick: option))
                }
            }
            switch selectedPickMusic {
            case .albums:
                LibraryAlbumsList()
            case .artists:
                LibraryArtistsList()
            case .songs:
                LibrarySongsList()
            }
        }
    }
}

#Preview {
    LibraryMusicPicker()
}
