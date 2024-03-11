//
//  StoredAlbum.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-13.
//

import SwiftUI

protocol Album {
    var AlbumID: String { get set }
    var Title: String { get set }
    var Artwork: String { get set }
    var AlbumType: String { get set }
    var Year: Int { get set }
    var Artists: [SearchedArtist] { get set }
}


struct SearchedAlbum: Codable, Hashable, Album {
    var AlbumID: String
    var Title: String
    var Artwork: String
    var AlbumType: String
    var Year: Int
    var Artists: [SearchedArtist] = []
    
    init() {
        self.AlbumID = UUID().uuidString
        self.Title = ""
        self.Artwork = ""
        self.AlbumType = "Album"
        self.Year = 2024
        self.Artists = []
    }
    init(default: Bool) {
        self.AlbumID = "MPREb_DaVYg3RUfP2"
        self.Title = "Love Sick (Deluxe)"
        self.Artwork = "iKd3qRCjYuyJ3qPdPmYY-KhBYpHC5LvbYYbBpwF8cbL1ImAl_-lX8FAPJBkLio_Acz7fTBDksNeGUBzFpg"
        self.AlbumType = "Album"
        self.Year = 2024
        self.Artists = [SearchedArtist(default: true)]
    }
    init(from: StoredAlbum) {
        self.AlbumID = from.AlbumID
        self.Title = from.Title
        self.Artwork = from.Artwork
        self.AlbumType = from.AlbumType
        self.Year = from.Year
        self.Artists = from.Artists
    }
    init(from: FetchedAlbum) {
        self.AlbumID = from.AlbumID
        self.Title = from.Title
        self.Artwork = from.Artwork
        self.AlbumType = from.AlbumType
        self.Year = from.Year
        self.Artists = from.Artists
    }
}

struct FetchedAlbum: Codable, Hashable, Album {
    var AlbumID: String
    var Title: String
    var Artwork: String
    var AlbumType: String
    var Year: Int
    var Artists: [SearchedArtist]
    var Tracks: [FetchedTrack]
    var Features: [SearchedArtist]
    
    init(from: [StoredTrack]) {
        self.AlbumID = from[0].Album.AlbumID
        self.Title = from[0].Album.Title
        self.Artwork = from[0].Album.Artwork
        self.AlbumType = from[0].Album.AlbumType
        self.Year = from[0].Album.Year
        self.Artists = from[0].Album.Artists
        self.Tracks = []
        self.Features = []
        for track in from {
            self.Tracks.append(FetchedTrack(from: track))
            for feature in track.Features {
                self.Features.append(feature)
            }
        }
    }
    init(from: [FetchedTrack]) {
        self.AlbumID = from[0].Album.AlbumID
        self.Title = from[0].Album.Title
        self.Artwork = from[0].Album.Artwork
        self.AlbumType = from[0].Album.AlbumType
        self.Year = from[0].Album.Year
        self.Artists = from[0].Album.Artists
        self.Tracks = []
        self.Features = []
        for track in from {
            self.Tracks.append(track)
            for feature in track.Features {
                self.Features.append(feature)
            }
        }
    }
}

struct StoredAlbum: Hashable, Album {
    var AlbumID: String
    var Title: String
    var Artwork: String
    var AlbumType: String
    var Year: Int
    var Artists: [SearchedArtist]
    var Tracks: [any Track]
    var Features: [SearchedArtist]
    
    init(from: [any Track]) {
        self.AlbumID = from[0].Album.AlbumID
        self.Title = from[0].Album.Title
        self.Artwork = from[0].Album.Artwork
        self.AlbumType = from[0].Album.AlbumType
        self.Year = from[0].Album.Year
        self.Artists = from[0].Album.Artists
        self.Tracks = []
        self.Features = []
        for track in from {
            self.Tracks.append(track)
            for feature in track.Features {
                self.Features.append(feature)
            }
        }
    }
    static func == (lhs: StoredAlbum, rhs: StoredAlbum) -> Bool {
        lhs.AlbumID == rhs.AlbumID
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(AlbumID)
    }
}
