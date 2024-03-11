//
//  LibraryEnums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-28.
//

import SwiftUI

enum LibraryPicks: String, CaseIterable, Identifiable {
    case recents, music, playlists
    var id: Self { self }
}

func libraryPickSymbol(pick: LibraryPicks) -> String {
    switch pick {
        case .recents:
            return("bookmark")
        case .music:
            return("play.square.stack")
        case .playlists:
            return("music.note.list")
    }
}

enum MusicPicks: String, CaseIterable, Identifiable {
    case albums, songs, artists
    var id: Self { self }
}

func musicPickSymbol(pick: MusicPicks) -> String {
    switch pick {
        case .albums:
            return("play.square.stack")
        case .songs:
            return("music.note")
        case .artists:
            return("music.mic")
    }
}
