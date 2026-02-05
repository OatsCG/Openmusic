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
    var viewID: UUID? = UUID()
    var AlbumID: String
    var Title: String
    var Artwork: String
    var AlbumType: String
    var Year: Int
    var Artists: [SearchedArtist] = []
    
    init(AlbumID: String, Title: String, Artwork: String, AlbumType: String, Year: Int, Artists: [SearchedArtist]) {
        self.AlbumID = AlbumID
        self.Title = Title
        self.Artwork = Artwork
        self.AlbumType = AlbumType
        self.Year = Year
        self.Artists = Artists
    }
    
    init() {
        AlbumID = UUID().uuidString
        Title = ""
        Artwork = ""
        AlbumType = "Album"
        Year = 2024
        Artists = []
    }
    
    init(default: Bool) {
        AlbumID = "MPREb_DaVYg3RUfP2"
        Title = "Love Sick (Deluxe)"
        Artwork = "iKd3qRCjYuyJ3qPdPmYY-KhBYpHC5LvbYYbBpwF8cbL1ImAl_-lX8FAPJBkLio_Acz7fTBDksNeGUBzFpg"
        AlbumType = "Album"
        Year = 2024
        Artists = [SearchedArtist(default: true)]
    }
    
    init(from: StoredAlbum) {
        AlbumID = from.AlbumID
        Title = from.Title
        Artwork = from.Artwork
        AlbumType = from.AlbumType
        Year = from.Year
        Artists = from.Artists
    }
    
    init(from: FetchedAlbum) {
        AlbumID = from.AlbumID
        Title = from.Title
        Artwork = from.Artwork
        AlbumType = from.AlbumType
        Year = from.Year
        Artists = from.Artists
    }
    
    private enum CodingKeys: String, CodingKey {
        case AlbumID, Title, Artwork, AlbumType, Year, Artists
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
        AlbumID = from[0].Album.AlbumID
        Title = from[0].Album.Title
        Artwork = from[0].Album.Artwork
        AlbumType = from[0].Album.AlbumType
        Year = from[0].Album.Year
        Artists = from[0].Album.Artists
        Tracks = []
        Features = []
        for track in from {
            Tracks.append(FetchedTrack(from: track))
            for feature in track.Features {
                Features.append(feature)
            }
        }
    }
    
    init(AlbumID: String, Title: String, Artwork: String, AlbumType: String, Year: Int, Artists: [SearchedArtist], Tracks: [FetchedTrack], Features: [SearchedArtist]) {
        self.AlbumID = AlbumID
        self.Title = Title
        self.Artwork = Artwork
        self.AlbumType = AlbumType
        self.Year = Year
        self.Artists = Artists
        self.Tracks = Tracks
        self.Features = Features
    }
    
    init(from: [FetchedTrack]) {
        AlbumID = from[0].Album.AlbumID
        Title = from[0].Album.Title
        Artwork = from[0].Album.Artwork
        AlbumType = from[0].Album.AlbumType
        Year = from[0].Album.Year
        Artists = from[0].Album.Artists
        Tracks = []
        Features = []
        for track in from {
            Tracks.append(track)
            for feature in track.Features {
                Features.append(feature)
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
        AlbumID = from[0].Album.AlbumID
        Title = from[0].Album.Title
        Artwork = from[0].Album.Artwork
        AlbumType = from[0].Album.AlbumType
        Year = from[0].Album.Year
        Artists = from[0].Album.Artists
        Tracks = []
        Features = []
        for track in from {
            Tracks.append(track)
            for feature in track.Features {
                Features.append(feature)
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
