//
//  StoredModel.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-29.
//

import Foundation
import SwiftData


protocol Track: Codable, Hashable, Sendable {
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
    
    init(TrackID: String, Title: String, Playback_Clean: String?, Playback_Explicit: String?, Length: Int, Index: Int, Views: Int, Album: SearchedAlbum, Features: [SearchedArtist]) {
        self.TrackID = TrackID
        self.Title = Title
        self.Playback_Clean = Playback_Clean
        self.Playback_Explicit = Playback_Explicit
        self.Length = Length
        self.Index = Index
        self.Views = Views
        self.Album = Album
        self.Features = Features
    }
    
    init() {
        TrackID = UUID().uuidString
        Title = ""
        Playback_Clean = nil
        Playback_Explicit = nil
        Length = 0
        Index = 1
        Views = 0
        Album = SearchedAlbum()
        Features = []
    }
    
    init(default: Bool) {
        TrackID = "-5648816593022018624"
        Title = "Private Landing (feat. Justin Bieber & Future)"
        Playback_Clean = ""
        Playback_Explicit = ""
        Length = 239
        Index = 13
        Views = 564000
        Album = SearchedAlbum(default: true)
        Features = []
    }

    init(from: StoredTrack) {
        TrackID = from.TrackID
        Title = from.Title
        Playback_Clean = from.Playback_Clean
        Playback_Explicit = from.Playback_Explicit
        Length = from.Length
        Index = from.Index
        Views = -1
        Album = from.Album
        Features = from.Features
    }
    
    init(from: ImportedTrack) {
        TrackID = from.TrackID
        Title = from.Title
        Playback_Clean = from.Playback_Clean
        Playback_Explicit = from.Playback_Explicit
        Length = from.Length
        Index = from.Index
        Views = from.Views
        Album = from.Album
        Features = from.Features
    }
    
    @MainActor
    init(from: QueueItem) {
        TrackID = from.Track.TrackID
        Title = from.Track.Title
        Playback_Clean = from.Track.Playback_Clean
        Playback_Explicit = from.Track.Playback_Explicit
        Length = from.Track.Length
        Index = from.Track.Index
        Views = -1
        Album = from.Track.Album
        Features = from.Track.Features
    }
    
    private enum CodingKeys: String, CodingKey {
        case TrackID, Title, Playback_Clean, Playback_Explicit, Length, Index, Views, Album, Features
    }
}

@Model
final class StoredTrack: Hashable, Track {
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
        TrackID = from.TrackID
        Title = from.Title
        Playback_Clean = from.Playback_Clean
        Playback_Explicit = from.Playback_Explicit
        Length = from.Length
        Index = from.Index
        Album = from.Album
        Features = from.Features
        dateAdded = Date()
        originServer = NetworkManager.globalIPAddress()
        Task.detached {
            await downloadAlbumArt(artworkID: from.Album.Artwork)
        }
    }
    
    @MainActor
    init(from: QueueItem) {
        TrackID = from.Track.TrackID
        Title = from.Track.Title
        Playback_Clean = from.Track.Playback_Clean
        Playback_Explicit = from.Track.Playback_Explicit
        Length = from.Track.Length
        Index = from.Track.Index
        Album = from.Track.Album
        Features = from.Track.Features
        dateAdded = Date()
        originServer = NetworkManager.globalIPAddress()
        Task.detached {
            await downloadAlbumArt(artworkID: from.Track.Album.Artwork)
        }
    }
    
    func setTrackID(to: String) {
        TrackID = to
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let TrackID = try values.decode(String.self, forKey: .TrackID)
        let Title = try values.decode(String.self, forKey: .Title)
        let Playback_Clean = try values.decode(String.self, forKey: .Playback_Clean)
        let Playback_Explicit = try values.decode(String.self, forKey: .Playback_Explicit)
        let Length = try values.decode(Int.self, forKey: .Length)
        let Index = try values.decode(Int.self, forKey: .Index)
        let Album = try values.decode(SearchedAlbum.self, forKey: .Album)
        let Features = try values.decode([SearchedArtist].self, forKey: .Features)
        let dateAdded = try values.decode(Date.self, forKey: .dateAdded)
        let originServer = try values.decode(String.self, forKey: .originServer)
        self.TrackID = TrackID
        self.Title = Title
        self.Playback_Clean = Playback_Clean
        self.Playback_Explicit = Playback_Explicit
        self.Length = Length
        self.Index = Index
        self.Album = Album
        self.Features = Features
        self.dateAdded = dateAdded
        self.originServer = originServer
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
        titleScore + albumScore + artistsScore
    }
    
    func lowest_score() -> Float {
        min(titleScore, albumScore, artistsScore)
    }
    
    func isAccurate() -> Bool {
        let trackAccurate = self.titleScore > 0.8
        let albumAccurate = self.albumScore > 0.3
        let artistAccurate = self.artistsScore > 0.7
        return trackAccurate && albumAccurate && artistAccurate
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
        lhs.title == rhs.title && lhs.album == rhs.album && lhs.artists == rhs.artists
    }
}
