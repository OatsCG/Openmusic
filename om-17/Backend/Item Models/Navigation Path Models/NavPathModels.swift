//
//  NavPathModels.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-07.
//

import SwiftUI

struct SearchAlbumContentNPM: Hashable {
    var album: SearchedAlbum
}

struct LibraryAlbumContentNPM: Hashable {
    var album: StoredAlbum
}

struct SearchArtistContentNPM: Hashable {
    var artist: SearchedArtist
}

struct LibraryArtistContentNPM: Hashable {
    var artist: SearchedArtist
    var albums: [FetchedAlbum]
    var features: [any Track]
    
    static func == (lhs: LibraryArtistContentNPM, rhs: LibraryArtistContentNPM) -> Bool {
        lhs.artist.ArtistID == rhs.artist.ArtistID
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.artist.ArtistID)
    }
}

struct SearchExtendedTracksNPM: Hashable {
    var tracks: [FetchedTrack]?
    var shouldQueueAll: Bool
}

struct SearchExtendedAlbumsNPM: Hashable {
    var albums: [SearchedAlbum]?
}

struct SearchExtendedArtistsNPM: Hashable {
    var artists: [SearchedArtist]?
}

struct PlaylistContentNPM: Hashable {
    var playlist: StoredPlaylist
}

struct SearchArtistExtendedTracksNPM: Hashable {
    var tracks: [any Track]?
    var artistName: String
    
    static func == (lhs: SearchArtistExtendedTracksNPM, rhs: SearchArtistExtendedTracksNPM) -> Bool {
        lhs.artistName == rhs.artistName
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.artistName)
    }
}

struct SearchArtistExtendedAlbumsNPM: Hashable {
    var albums: [SearchedAlbum]?
    var artistName: String
}

struct SearchArtistExtendedSinglesNPM: Hashable {
    var albums: [SearchedAlbum]?
    var artistName: String
}

struct LibraryArtistExtendedAlbumsNPM: Hashable {
    var albums: [FetchedAlbum]
    var artistName: String
}

struct PlaylistReviewTracksNPM: Hashable {
    var playlist: StoredPlaylist
}

struct PlaylistEditMenuNPM: Hashable {
    var playlist: StoredPlaylist
}

struct UserViewNPM: Hashable {
    
}

struct FileManagerNPM: Hashable {
    
}

struct ManageAudiosNPM: Hashable {
    
}

struct ManageImagesNPM: Hashable {
    
}
