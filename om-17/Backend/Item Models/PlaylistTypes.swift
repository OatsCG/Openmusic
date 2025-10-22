//
//  Playlist.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-30.
//

import Foundation
import SwiftData
import SwiftUI

protocol Playlist {
    var PlaylistID: UUID { get set }
    var Title: String { get set }
    var Bio: String { get set }
    var Image: String? { get set }
    var dateCreated: Date { get set }
    var pinned: Bool { get set }
    var items: [PlaylistItem] { get set }
}

class SearchedPlaylist: Hashable, Playlist {
    var PlaylistID: UUID
    var Title: String
    var Bio: String
    var Image: String?
    var dateCreated: Date
    var pinned: Bool = false
    var items: [PlaylistItem]
    
    init(Title: String) {
        PlaylistID = UUID()
        self.Title = Title
        Bio = ""
        Image = ""
        dateCreated = Date()
        items = []
    }
    
    static func == (lhs: SearchedPlaylist, rhs: SearchedPlaylist) -> Bool {
        lhs.PlaylistID == rhs.PlaylistID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(PlaylistID)
    }
}

@Model
class StoredPlaylist: Hashable, Playlist {
    var PlaylistID: UUID
    var Title: String
    var Bio: String
    var Image: String?
    var dateCreated: Date
    var importURL: String?
    var pinned: Bool = false
    var items: [PlaylistItem]
    
    init(Title: String) {
        PlaylistID = UUID()
        self.Title = Title
        Bio = ""
        Image = nil
        dateCreated = Date()
        importURL = nil
        items = []
    }
    
    init(Title: String, Bio: String, Image: String, importURL: String) {
        PlaylistID = UUID()
        self.Title = Title
        self.Bio = Bio
        self.Image = Image
        dateCreated = Date()
        self.importURL = importURL
        items = []
        downloadPlaylistArt(playlistID: PlaylistID, ArtworkURL: Image)
    }
    
    init(fetchedInfoTracks: FetchedPlaylistInfoTracks, platform: Platform) async {
        PlaylistID = UUID()
        Title = fetchedInfoTracks.name
        Bio = fetchedInfoTracks.description
        Image = fetchedInfoTracks.artwork
        dateCreated = Date()
        importURL = nil
        items = []
        for track in fetchedInfoTracks.tracks {
            let item = await PlaylistItem(importData: ImportData(from: ImportedFrom(platform: platform, url: "", title: track.title, album: track.album, artist: track.artists), status: .hold, dateAdded: Date()), playlistID: PlaylistID, index: items.count)
            items.append(item)
        }
        downloadPlaylistArt(playlistID: PlaylistID, ArtworkURL: fetchedInfoTracks.artwork)
    }
    
    init(from: ImportedPlaylist) async {
        PlaylistID = UUID()
        Title = from.Title
        Bio = from.Bio
        Image = from.Image
        dateCreated = from.dateCreated
        importURL = from.importURL
        items = []
        for item in from.items {
            await items.append(PlaylistItem(from: item))
        }
        downloadPlaylistArt(playlistID: PlaylistID, ArtworkURL: from.Image ?? "")
    }
    
    func pin() {
        withAnimation {
            pinned = true
        }
    }
    
    func unpin() {
        withAnimation {
            pinned = false
        }
    }
    
    func add_item(item: PlaylistItem) {
        items.append(item)
        ToastManager.shared.propose(toast: Toast.playlist(item.track.Album.Artwork, playlist: self))
    }
    
    func add_items(items: [PlaylistItem]) {
        for item in items {
            self.items.append(item)
        }
        ToastManager.shared.propose(toast: Toast.playlist(items.first?.track.Album.Artwork, playlist: self, count: items.count))
    }
    
    @MainActor
    func add_track(track: any Track) {
        items.append(PlaylistItem(track: track, playlistID: PlaylistID, index: items.count))
        ToastManager.shared.propose(toast: Toast.playlist(track.Album.Artwork, playlist: self))
    }
    
    @MainActor
    func add_track(queueItem: QueueItem) {
        items.append(PlaylistItem(queueItem: queueItem, playlistID: PlaylistID, index: items.count))
        ToastManager.shared.propose(toast: Toast.playlist(queueItem.Track.Album.Artwork, playlist: self))
    }
    
    @MainActor
    func add_tracks(tracks: [any Track]) {
        for track in tracks {
            items.append(PlaylistItem(track: track, playlistID: PlaylistID, index: items.count))
        }
        ToastManager.shared.propose(toast: Toast.playlist(tracks.first?.Album.Artwork, playlist: self))
    }
    
    @MainActor
    func add_tracks(queueItems: [QueueItem]) {
        for queueItem in queueItems {
            items.append(PlaylistItem(queueItem: queueItem, playlistID: PlaylistID, index: items.count))
        }
        ToastManager.shared.propose(toast: Toast.playlist(queueItems.first?.Track.Album.Artwork, playlist: self))
    }
    
    func performMove(source: IndexSet, destination: Int) {
        var updatedList = items
        updatedList.move(fromOffsets: source, toOffset: destination)
        items = updatedList
    }
    
    func mutate_item(item: PlaylistItem) {
        if let itemIndex = items.firstIndex(where: { $0.id == item.id }) {
            print(">mutate setting item")
            items[itemIndex] = item
            print(item.importData.status)
            print(items[itemIndex].importData.status)
            print(">mutate success")
        }
    }
}

@MainActor
struct PlaylistItem: Codable, Hashable {
    var id: UUID
    var playlistID: UUID
    var track: FetchedTrack
    var explicit: Bool
    var timesPlayed: Int
    var importData: ImportData
    
    init(track: any Track, playlistID: UUID, explicit: Bool? = nil, index: Int) {
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack()
        if track is FetchedTrack {
            self.track = (track as? FetchedTrack)!
        } else if track is StoredTrack {
            self.track = FetchedTrack(from: (track as? StoredTrack)!)
        }
        
        self.explicit = explicit ?? (track.Playback_Explicit != nil)
        self.importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        self.timesPlayed = 0
    }
    
    init(importData: ImportData, playlistID: UUID, index: Int) {
        id = UUID()
        self.playlistID = playlistID
        track = FetchedTrack()
        explicit = false
        self.importData = importData
        timesPlayed = 0
    }
    
    init(queueItem: QueueItem, playlistID: UUID, explicit: Bool? = nil, index: Int) {
        id = UUID()
        self.playlistID = playlistID
        track = FetchedTrack(from: queueItem)
        self.explicit = explicit ?? (queueItem.Track.Playback_Explicit != nil)
        importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        self.timesPlayed = 0
    }
    
    init(from: PlaylistImport) {
        id = UUID()
        playlistID = from.playlistID
        track = from.track
        explicit = from.explicit
        importData = from.importData
        timesPlayed = 0
    }
    
    mutating func set_status(status: ImportStatus) {
        importData.status = status
    }
    
    mutating func set_imports(tracks: ImportedTracks) {
        importData.possibleImports = tracks.Tracks
    }
    
    mutating func set_successful_track(track: ImportedTrack) {
        self.track = FetchedTrack(from: track)
        explicit = self.track.Playback_Explicit != nil
        importData.status = .success
    }
    
    static nonisolated func == (lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable final class ImportedPlaylist: Hashable, Sendable {
    var PlaylistID: UUID
    var Title: String
    var Bio: String
    var Image: String?
    var dateCreated: Date
    var importURL: String?
    var items: [PlaylistImport]

    init(fetchedInfoTracks: FetchedPlaylistInfoTracks, importURL: String, platform: Platform) {
        self.PlaylistID = UUID()
        self.Title = fetchedInfoTracks.name
        self.Bio = fetchedInfoTracks.description
        self.Image = fetchedInfoTracks.artwork
        self.dateCreated = Date()
        self.importURL = importURL
        self.items = []
        for track in fetchedInfoTracks.tracks {
            let item = PlaylistImport(importData: ImportData(from: ImportedFrom(platform: platform, url: "", title: track.title, album: track.album, artist: track.artists), status: .hold, dateAdded: Date()), playlistID: self.PlaylistID, index: self.items.count)
            self.items.append(item)
        }
    }
    
    func add_item(item: PlaylistImport) {
        items.append(item)
    }
    
    func add_items(items: [PlaylistImport]) {
        for item in items {
            self.items.append(item)
        }
    }
    
    func add_track(track: any Track) {
        items.append(PlaylistImport(track: track, playlistID: PlaylistID, index: items.count))
    }
    
    func add_track(queueItem: QueueItem) async {
        await items.append(PlaylistImport(queueItem: queueItem, playlistID: PlaylistID, index: items.count))
    }
    
    func add_tracks(tracks: [any Track]) {
        for track in tracks {
            items.append(PlaylistImport(track: track, playlistID: PlaylistID, index: items.count))
        }
    }
    
    func add_tracks(queueItems: [QueueItem]) async {
        for queueItem in queueItems {
            await items.append(PlaylistImport(queueItem: queueItem, playlistID: PlaylistID, index: items.count))
        }
    }
    
    func performMove(source: IndexSet, destination: Int) {
        var updatedList = items
        updatedList.move(fromOffsets: source, toOffset: destination)
        items = updatedList
    }
    
    func is_importing_successful() -> Bool {
        self.import_progress() == 1
    }
    
    func import_progress() -> Double {
        let completedItems: Int = items.filter{ [ImportStatus.zeroed, ImportStatus.uncertain, ImportStatus.success].contains($0.importData.status)}.count
        return Double(completedItems) / Double(items.count)
    }
    
    static func ==(lhs: ImportedPlaylist, rhs: ImportedPlaylist) -> Bool {
        lhs.PlaylistID == rhs.PlaylistID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(PlaylistID)
    }
}

@Observable final class PlaylistImport: Codable, Hashable, Sendable {
    var id: UUID
    var playlistID: UUID
    var track: FetchedTrack
    var explicit: Bool
    var timesPlayed: Int
    var importData: ImportData
    
    init(track: any Track, playlistID: UUID, explicit: Bool? = nil, index: Int) {
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack()
        if track is FetchedTrack {
            self.track = (track as? FetchedTrack)!
        } else if track is StoredTrack {
            self.track = FetchedTrack(from: (track as? StoredTrack)!)
        }
        self.explicit = explicit ?? (track.Playback_Explicit != nil)
        self.importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        self.timesPlayed = 0
    }
    
    init(importData: ImportData, playlistID: UUID, index: Int) {
        id = UUID()
        self.playlistID = playlistID
        track = FetchedTrack()
        explicit = false
        self.importData = importData
        timesPlayed = 0
    }
    
    init(queueItem: QueueItem, playlistID: UUID, explicit: Bool? = nil, index: Int) async {
        id = UUID()
        self.playlistID = playlistID
        importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        timesPlayed = 0
        track = await FetchedTrack(from: queueItem)
        if let explicit = explicit {
            self.explicit = explicit
        } else {
            self.explicit = await queueItem.Track.Playback_Explicit != nil
        }
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        playlistID = try values.decode(UUID.self, forKey: .playlistID)
        track = try values.decode(FetchedTrack.self, forKey: .track)
        explicit = try values.decode(Bool.self, forKey: .explicit)
        timesPlayed = try values.decode(Int.self, forKey: .timesPlayed)
        importData = try values.decode(ImportData.self, forKey: .importData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(playlistID, forKey: .playlistID)
        try container.encode(track, forKey: .track)
        try container.encode(explicit, forKey: .explicit)
        try container.encode(timesPlayed, forKey: .timesPlayed)
        try container.encode(importData, forKey: .importData)
    }
    
    func set_status(status: ImportStatus) {
        importData.status = status
    }
    
    func set_imports(tracks: ImportedTracks) {
        importData.possibleImports = tracks.Tracks
    }
    
    func set_successful_track(track: ImportedTrack) {
        self.track = FetchedTrack(from: track)
        explicit = self.track.Playback_Explicit != nil
        importData.status = .success
    }
    
    static func ==(lhs: PlaylistImport, rhs: PlaylistImport) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, playlistID, track, explicit, timesPlayed, importData
    }
}

struct ImportData: Codable, Hashable {
    var id: UUID
    var from: ImportedFrom
    var status: ImportStatus
    var dateAdded: Date
    var possibleImports: [ImportedTrack]
    
    init(from: ImportedFrom, status: ImportStatus, dateAdded: Date) {
        id = UUID()
        self.from = from
        self.status = status
        self.dateAdded = dateAdded
        possibleImports = []
    }
    
    static func ==(lhs: ImportData, rhs: ImportData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ImportedFrom: Codable, Hashable {
    var id: UUID
    var platform: Platform
    var url: String?
    var title: String?
    var album: String?
    var artist: String?

    init(platform: Platform) {
        id = UUID()
        self.platform = platform
        url = nil
        title = nil
        album = nil
        artist = nil
    }
    
    init(platform: Platform, url: String, title: String, album: String, artist: String) {
        id = UUID()
        self.platform = platform
        self.url = url
        self.title = title
        self.album = album
        self.artist = artist
    }
    
    static func ==(lhs: ImportedFrom, rhs: ImportedFrom) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FetchedPlaylistInfo: Codable, Hashable {
    var name: String = ""
    var description: String = ""
    var artwork: String = ""
    var playlistID: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case name, description, artwork, playlistID
    }
}

struct FetchedPlaylistInfoTracks: Codable, Hashable {
    var name: String = ""
    var description: String = ""
    var artwork: String = ""
    var playlistID: String = ""
    var tracks: [FetchedPlaylistTrack] = []
    
    private enum CodingKeys: String, CodingKey {
        case name, description, artwork, playlistID, tracks
    }
}

struct FetchedPlaylistTrack: Codable, Hashable {
    var title: String = ""
    var album: String = ""
    var artists: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case title, album, artists
    }
}


enum Platform: String, Codable, Identifiable, CaseIterable {
    case openmusic, apple, spotify, unknown
    var id: Self { self }
}

enum ImportStatus: Codable, Identifiable, CaseIterable {
    case hold, importing, zeroed, uncertain, success
    // not started, fetching from server, error occured, fetching stopped, returned zero results, best result isnt perfect, best result found
    var id: Self { self }
}
