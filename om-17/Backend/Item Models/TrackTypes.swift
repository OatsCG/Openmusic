//
//  StoredModel.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-29.
//

import Foundation
import SwiftData

protocol Track: Codable, Hashable {
    var TrackID: String { get set }
    var Title: String { get set }
    var Playback_Clean: String? { get set }
    var Playback_Explicit: String? { get set }
    var Length: Int { get set }
    var Index: Int { get set }
    var Album: SearchedAlbum { get set }
    var Features: [SearchedArtist] { get set }
}

struct FetchedTrack: Codable, Hashable, Track {
    var TrackID: String
    var Title: String
    var Playback_Clean: String?
    var Playback_Explicit: String?
    var Length: Int
    var Index: Int
    var Views: Int
    var Album: SearchedAlbum
    var Features: [SearchedArtist]
    
    init() {
        self.TrackID = UUID().uuidString
        self.Title = ""
        self.Playback_Clean = nil
        self.Playback_Explicit = nil
        self.Length = 0
        self.Index = 1
        self.Views = 0
        self.Album = SearchedAlbum()
        self.Features = []
    }
    
    init(default: Bool) {
        self.TrackID = "-5648816593022018624"
        self.Title = "Private Landing (feat. Justin Bieber & Future)"
        self.Playback_Clean = ""
        self.Playback_Explicit = ""
        self.Length = 239
        self.Index = 13
        self.Views = 564000
        self.Album = SearchedAlbum(default: true)
        self.Features = []
    }

    init(from: StoredTrack) {
        self.TrackID = from.TrackID
        self.Title = from.Title
        self.Playback_Clean = from.Playback_Clean
        self.Playback_Explicit = from.Playback_Explicit
        self.Length = from.Length
        self.Index = from.Index
        self.Views = -1
        self.Album = from.Album
        self.Features = from.Features
    }
    init(from: ImportedTrack) {
        self.TrackID = from.TrackID
        self.Title = from.Title
        self.Playback_Clean = from.Playback_Clean
        self.Playback_Explicit = from.Playback_Explicit
        self.Length = from.Length
        self.Index = from.Index
        self.Views = from.Views
        self.Album = from.Album
        self.Features = from.Features
    }
    init(from: QueueItem) {
        self.TrackID = from.Track.TrackID
        self.Title = from.Track.Title
        self.Playback_Clean = from.Track.Playback_Clean
        self.Playback_Explicit = from.Track.Playback_Explicit
        self.Length = from.Track.Length
        self.Index = from.Track.Index
        self.Views = -1
        self.Album = from.Track.Album
        self.Features = from.Track.Features
    }
    
    private enum CodingKeys: String, CodingKey {
        case TrackID, Title, Playback_Clean, Playback_Explicit, Length, Index, Views, Album, Features
    }
}

@Model
class StoredTrack: Hashable, Track {
    @Attribute(.unique) var TrackID: String
    var Title: String
    var Playback_Clean: String?
    var Playback_Explicit: String?
    var Length: Int
    var Index: Int
    var Album: SearchedAlbum
    var Features: [SearchedArtist]
    var dateAdded: Date
    var originServer: String
    
    init(from: any Track) {
        self.TrackID = from.TrackID
        self.Title = from.Title
        self.Playback_Clean = from.Playback_Clean
        self.Playback_Explicit = from.Playback_Explicit
        self.Length = from.Length
        self.Index = from.Index
        self.Album = from.Album
        self.Features = from.Features
        self.dateAdded = Date()
        self.originServer = globalIPAddress()
        Task {
            downloadAlbumArt(ArtworkID: from.Album.Artwork, completion: {_ in })
        }
    }
    init(from: QueueItem) {
        self.TrackID = from.Track.TrackID
        self.Title = from.Track.Title
        self.Playback_Clean = from.Track.Playback_Clean
        self.Playback_Explicit = from.Track.Playback_Explicit
        self.Length = from.Track.Length
        self.Index = from.Track.Index
        self.Album = from.Track.Album
        self.Features = from.Track.Features
        self.dateAdded = Date()
        self.originServer = globalIPAddress()
        Task {
            downloadAlbumArt(ArtworkID: from.Track.Album.Artwork, completion: {_ in })
        }
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.TrackID = try values.decode(String.self, forKey: .TrackID)
        self.Title = try values.decode(String.self, forKey: .Title)
        self.Playback_Clean = try values.decode(String.self, forKey: .Playback_Clean)
        self.Playback_Explicit = try values.decode(String.self, forKey: .Playback_Explicit)
        self.Length = try values.decode(Int.self, forKey: .Length)
        self.Index = try values.decode(Int.self, forKey: .Index)
        self.Album = try values.decode(SearchedAlbum.self, forKey: .Album)
        self.Features = try values.decode([SearchedArtist].self, forKey: .Features)
        self.dateAdded = try values.decode(Date.self, forKey: .dateAdded)
        self.originServer = try values.decode(String.self, forKey: .originServer)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(TrackID, forKey: .TrackID)
        try container.encode(Playback_Clean, forKey: .Playback_Clean)
        try container.encode(Playback_Explicit, forKey: .Playback_Explicit)
        try container.encode(Length, forKey: .Length)
        try container.encode(Index, forKey: .Index)
        try container.encode(Album, forKey: .Album)
        try container.encode(Features, forKey: .Features)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(originServer, forKey: .originServer)
    }
    
    private enum CodingKeys: String, CodingKey {
        case TrackID, Title, Playback_Clean, Playback_Explicit, Length, Index, Album, Features, dateAdded, originServer
    }
}

struct FetchedTracks: Codable, Hashable {
    var Tracks: [FetchedTrack]
    
    private enum CodingKeys: String, CodingKey {
        case Tracks
    }
}

struct ImportedTracks: Codable, Hashable {
    var Tracks: [ImportedTrack]
    
    private enum CodingKeys: String, CodingKey {
        case Tracks
    }
}

struct ImportedTrack: Codable, Hashable, Track {
    var TrackID: String
    var Title: String
    var Playback_Clean: String?
    var Playback_Explicit: String?
    var Length: Int
    var Index: Int
    var Views: Int
    var Album: SearchedAlbum
    var Features: [SearchedArtist]
    var titleScore: Float
    var albumScore: Float
    var artistsScore: Float
    
    func score() -> Float {
        return titleScore + albumScore + artistsScore
    }
    
    func lowest_score() -> Float {
        return min(titleScore, albumScore, artistsScore)
    }
    
    func isAccurate() -> Bool {
        let trackAccurate = self.titleScore > 0.8
        let albumAccurate = self.albumScore > 0.3
        let artistAccurate = self.artistsScore > 0.7
        if (trackAccurate && albumAccurate && artistAccurate) {
            return true
        } else {
            return false
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case TrackID, Title, Playback_Clean, Playback_Explicit, Length, Index, Views, Album, Features, titleScore, albumScore, artistsScore
    }
}

struct NaiveTrack: Equatable {
    var title: String
    var album: String
    var artists: String
    
    static func ==(lhs: NaiveTrack, rhs: NaiveTrack) -> Bool {
        return lhs.title == rhs.title && lhs.album == rhs.album && lhs.artists == rhs.artists
    }
}
