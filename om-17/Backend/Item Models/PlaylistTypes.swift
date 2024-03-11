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
        self.PlaylistID = UUID()
        self.Title = Title
        self.Bio = ""
        self.Image = ""
        self.dateCreated = Date()
        self.items = []
    }
    
    static func == (lhs: SearchedPlaylist, rhs: SearchedPlaylist) -> Bool {
        return lhs.PlaylistID == rhs.PlaylistID
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
        self.PlaylistID = UUID()
        self.Title = Title
        self.Bio = ""
        self.Image = nil
        self.dateCreated = Date()
        self.importURL = nil
        self.items = []
    }
    init(Title: String, Bio: String, Image: String, importURL: String) {
        self.PlaylistID = UUID()
        self.Title = Title
        self.Bio = Bio
        self.Image = Image
        self.dateCreated = Date()
        self.importURL = importURL
        self.items = []
        Task {
            await downloadPlaylistArt(playlistID: self.PlaylistID, ArtworkURL: Image)
        }
    }
    init(fetchedInfoTracks: FetchedPlaylistInfoTracks, platform: Platform) {
        self.PlaylistID = UUID()
        self.Title = fetchedInfoTracks.name
        self.Bio = fetchedInfoTracks.description
        self.Image = fetchedInfoTracks.artwork
        self.dateCreated = Date()
        self.importURL = nil
        self.items = []
        for track in fetchedInfoTracks.tracks {
            let item = PlaylistItem(importData: ImportData(from: ImportedFrom(platform: platform, url: "", title: track.title, album: track.album, artist: track.artists), status: .hold, dateAdded: Date()), playlistID: self.PlaylistID, index: self.items.count)
            self.items.append(item)
        }
        Task {
            await downloadPlaylistArt(playlistID: self.PlaylistID, ArtworkURL: fetchedInfoTracks.artwork)
        }
    }
    init(from: ImportedPlaylist) {
        self.PlaylistID = UUID()
        self.Title = from.Title
        self.Bio = from.Bio
        self.Image = from.Image
        self.dateCreated = from.dateCreated
        self.importURL = from.importURL
        self.items = []
        for item in from.items {
            let playlistItem: PlaylistItem = PlaylistItem(from: item)
            self.items.append(playlistItem)
        }
        Task {
            await downloadPlaylistArt(playlistID: self.PlaylistID, ArtworkURL: from.Image ?? "")
        }
    }
    
    func pin() {
        withAnimation {
            self.pinned = true
        }
    }
    
    func unpin() {
        withAnimation {
            self.pinned = false
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
    func add_track(track: any Track) {
        self.items.append(PlaylistItem(track: track, playlistID: self.PlaylistID, index: self.items.count))
        ToastManager.shared.propose(toast: Toast.playlist(track.Album.Artwork, playlist: self))
    }
    func add_track(queueItem: QueueItem) {
        self.items.append(PlaylistItem(queueItem: queueItem, playlistID: self.PlaylistID, index: self.items.count))
        ToastManager.shared.propose(toast: Toast.playlist(queueItem.Track.Album.Artwork, playlist: self))
    }
    func add_tracks(tracks: [any Track]) {
        for track in tracks {
            self.items.append(PlaylistItem(track: track, playlistID: self.PlaylistID, index: self.items.count))
        }
        ToastManager.shared.propose(toast: Toast.playlist(tracks.first?.Album.Artwork, playlist: self))
    }
    func add_tracks(queueItems: [QueueItem]) {
        for queueItem in queueItems {
            self.items.append(PlaylistItem(queueItem: queueItem, playlistID: self.PlaylistID, index: self.items.count))
        }
        ToastManager.shared.propose(toast: Toast.playlist(queueItems.first?.Track.Album.Artwork, playlist: self))
    }
    
    func performMove(source: IndexSet, destination: Int) {
        var updatedList = self.items
        updatedList.move(fromOffsets: source, toOffset: destination)
        self.items = updatedList
    }
    
    func mutate_item(item: PlaylistItem) {
        print(">mutate getting index")
        let itemIndex: Int? = self.items.firstIndex(where: { $0.id == item.id })
        if let itemIndex {
            print(">mutate setting item")
            self.items[itemIndex] = item
            print(item.importData.status)
            print(self.items[itemIndex].importData.status)
            print(">mutate success")
        }
    }
}

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
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack()
        self.explicit = false
        self.importData = importData
        self.timesPlayed = 0
    }
    init(queueItem: QueueItem, playlistID: UUID, explicit: Bool? = nil, index: Int) {
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack(from: queueItem)
        self.explicit = explicit ?? (queueItem.Track.Playback_Explicit != nil)
        self.importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        self.timesPlayed = 0
    }
    init(from: PlaylistImport) {
        self.id = UUID()
        self.playlistID = from.playlistID
        self.track = from.track
        self.explicit = from.explicit
        self.importData = from.importData
        self.timesPlayed = 0
    }
    
    mutating func set_status(status: ImportStatus) {
        self.importData.status = status
    }
    
    mutating func set_imports(tracks: ImportedTracks) {
        self.importData.possibleImports = tracks.Tracks
    }
    
    mutating func set_successful_track(track: ImportedTrack) {
        self.track = FetchedTrack(from: track)
        self.explicit = self.track.Playback_Explicit != nil
        self.importData.status = .success
    }
    
    static func == (lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable class ImportedPlaylist: Hashable {
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
        self.items.append(PlaylistImport(track: track, playlistID: self.PlaylistID, index: self.items.count))
    }
    func add_track(queueItem: QueueItem) {
        self.items.append(PlaylistImport(queueItem: queueItem, playlistID: self.PlaylistID, index: self.items.count))
    }
    func add_tracks(tracks: [any Track]) {
        for track in tracks {
            self.items.append(PlaylistImport(track: track, playlistID: self.PlaylistID, index: self.items.count))
        }
    }
    func add_tracks(queueItems: [QueueItem]) {
        for queueItem in queueItems {
            self.items.append(PlaylistImport(queueItem: queueItem, playlistID: self.PlaylistID, index: self.items.count))
        }
    }
    
    func performMove(source: IndexSet, destination: Int) {
        var updatedList = self.items
        updatedList.move(fromOffsets: source, toOffset: destination)
        self.items = updatedList
    }
    
    func is_importing_successful() -> Bool {
        if self.import_progress() == 1 {
            return true
        } else {
            return false
        }
//        if self.items.contains(where: { $0.importData.status == .hold || $0.importData.status == .importing }) {
//            return false
//        } else {
//            return true
//        }
    }
    
    func import_progress() -> Double {
        let totalItems: Int = self.items.count
        let completedItems: Int = self.items.filter{ [ImportStatus.zeroed, ImportStatus.uncertain, ImportStatus.success].contains($0.importData.status)}.count
        let progress: Double = Double(completedItems) / Double(totalItems)
        return progress
    }
    
    static func == (lhs: ImportedPlaylist, rhs: ImportedPlaylist) -> Bool {
        return lhs.PlaylistID == rhs.PlaylistID
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(PlaylistID)
    }
}

@Observable class PlaylistImport: Codable, Hashable {
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
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack()
        self.explicit = false
        self.importData = importData
        self.timesPlayed = 0
    }
    init(queueItem: QueueItem, playlistID: UUID, explicit: Bool? = nil, index: Int) {
        self.id = UUID()
        self.playlistID = playlistID
        self.track = FetchedTrack(from: queueItem)
        self.explicit = explicit ?? (queueItem.Track.Playback_Explicit != nil)
        self.importData = ImportData(from: ImportedFrom(platform: .openmusic), status: .success, dateAdded: Date())
        self.timesPlayed = 0
    }
    
    func set_status(status: ImportStatus) {
        self.importData.status = status
    }
    
    func set_imports(tracks: ImportedTracks) {
        self.importData.possibleImports = tracks.Tracks
    }
    
    func set_successful_track(track: ImportedTrack) {
        self.track = FetchedTrack(from: track)
        self.explicit = self.track.Playback_Explicit != nil
        self.importData.status = .success
    }
    
    static func ==(lhs: PlaylistImport, rhs: PlaylistImport) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct ImportData: Codable, Hashable {
    var id: UUID
    var from: ImportedFrom
    var status: ImportStatus
    var dateAdded: Date
    var possibleImports: [ImportedTrack]
    
    init(from: ImportedFrom, status: ImportStatus, dateAdded: Date) {
        self.id = UUID()
        self.from = from
        self.status = status
        self.dateAdded = dateAdded
        self.possibleImports = []
    }
    static func == (lhs: ImportData, rhs: ImportData) -> Bool {
        return lhs.id == rhs.id
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
        self.id = UUID()
        self.platform = platform
        self.url = nil
        self.title = nil
        self.album = nil
        self.artist = nil
    }
    init(platform: Platform, url: String, title: String, album: String, artist: String) {
        self.id = UUID()
        self.platform = platform
        self.url = url
        self.title = title
        self.album = album
        self.artist = artist
    }
    static func == (lhs: ImportedFrom, rhs: ImportedFrom) -> Bool {
        return lhs.id == rhs.id
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
