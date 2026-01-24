//
//  NavidromeTypes.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import Foundation

struct SubsonicResponseStatus: Codable {
    var status: String
    var version: String
    var type: String
    var serverVersion: String
    var openSubsonic: Bool
    var error: SubsonicError?
}

struct SubsonicError: Codable {
    var code: Int
    var message: String
}

struct NavidromeServerStatus: Codable {
    var subsonicresponse: SubsonicResponseStatus
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct SubsonicResponseSearch: Codable {
    var status: String
    var version: String
    var type: String
    var serverVersion: String
    var openSubsonic: Bool
    var searchResult2: SubsonicSearchResults
}

struct SubsonicSearchResults: Codable {
    var artist: [NDArtist]
    var album: [NDAlbum]
    var song: [NDSong]
}

struct SubsonicAlbumResults: Codable {
    var album: [NDAlbum]
}

struct SubsonicFetchedAlbum: Codable {
    var album: NDFetchedAlbum
}

struct SubsonicFetchedArtist: Codable {
    var artist: NDFetchedArtist
}

struct SubsonicAlbumList: Codable {
    var status: String
    var version: String
    var type: String
    var serverVersion: String
    var openSubsonic: Bool
    var albumList: SubsonicAlbumResults
}

struct NDArtist: Codable {
    var id: String
    var name: String
    var coverArt: String
    var artistImageUrl: String
}

struct NDArtistSimple: Codable {
    var id: String
    var name: String
}

struct NDFetchedArtist: Codable {
    var id: String
    var name: String
    var artistImageUrl: String
    var album: [NDFetchedArtistAlbum]
}

struct NDContributor: Codable {
    var role: String
    var artist: NDArtistSimple
}

struct NDAlbum: Codable {
    var id: String
    var parent: String
    var isDir: Bool
    var title: String
    var name: String
    var album: String
    var artist: String
    var year: Int
    var coverArt: String
    var duration: Int
    var created: String
    var artistId: String
    var songCount: Int
    var isVideo: Bool
    var bpm: Int
    var comment: String
    var sortName: String
    var mediaType: String
    var musicBrainzId: String
    var isrc: [String]
    var genres: [String]
    var channelCount: Int
    var samplingRate: Int
    var bitDepth: Int
    var moods: [String]
    var artists: [NDArtistSimple]
    var displayArtist: String
    var albumArtists: [NDArtistSimple]
    var displayAlbumArtist: String
    var contributors: [NDContributor]
    var displayComposer: String
    var explicitStatus: String
}

struct NDFetchedAlbum: Codable {
    var id: String
    var name: String
    var artist: String
    var year: Int
    var coverArt: String
    var duration: Int
    var created: String
    var artistId: String
    var songCount: Int
    var sortName: String
    var musicBrainzId: String
    var genres: [String]
    var moods: [String]
    var artists: [NDArtistSimple]
    
    var displayArtist: String
    var explicitStatus: String
    var song: [NDSong]
}

struct NDFetchedArtistAlbum: Codable {
    var id: String
    var name: String
    var artist: String
    var year: Int
    var coverArt: String
    var duration: Int
    var created: String
    var artistId: String
    var songCount: Int
    var sortName: String
    var musicBrainzId: String
    var genres: [String]
    var moods: [String]
    var artists: [NDArtistSimple]
    
    var displayArtist: String
    var explicitStatus: String
}

struct NDSong: Codable {
    var id: String
    var parent: String
    var isDir: Bool
    var title: String
    var album: String
    var artist: String
    var track: Int
    var year: Int
    var coverArt: String
    var size: Int
    var contentType: String
    var suffix: String
    var duration: Int
    var bitRate: Int
    var path: String
    var created: String
    var albumId: String
    var artistId: String
    var type: String
    var isVideo: Bool
    var bpm: Int
    var comment: String
    var sortName: String
    var mediaType: String
    var musicBrainzId: String
    var isrc: [String]
    var genres: [String]
    var channelCount: Int
    var samplingRate: Int
    var bitDepth: Int
    var moods: [String]
    var artists: [NDArtistSimple]
    var displayArtist: String
    var albumArtists: [NDArtistSimple]
    var displayAlbumArtist: String
    var contributors: [NDContributor]
    var displayComposer: String
    var explicitStatus: String
}

struct NavidromeSearch: Codable {
    var subsonicresponse: SubsonicResponseSearch
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct NavidromeAlbumList: Codable {
    var subsonicresponse: SubsonicAlbumList
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct NavidromeFetchedAlbum: Codable {
    var subsonicresponse: SubsonicFetchedAlbum
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct NavidromeFetchedArtist: Codable {
    var subsonicresponse: SubsonicFetchedArtist
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct NavidromeSong: Codable {
    var subsonicresponse: SubsonicResponseSong
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct SubsonicResponseSong: Codable {
    var status: String
    var version: String
    var type: String
    var serverVersion: String
    var openSubsonic: Bool
    var song: NDSong
}
