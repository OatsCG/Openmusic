//
//  NavidromeTypes.swift
//  om-17
//
//  Created by Charlie Giannis on 2025-09-11.
//

import Foundation

struct SubsonicResponseStatus: Codable {
    var serverVersion: String
    var error: SubsonicError?
    
    private enum CodingKeys: String, CodingKey {
        case serverVersion, error
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        serverVersion = (try? values?.decode(String.self, forKey: .serverVersion)) ?? ""
        error = (try? values?.decode(SubsonicError.self, forKey: .error)) ?? nil
    }
}

struct SubsonicError: Codable {
    var code: Int
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case code, message
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        code = (try? values?.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values?.decode(String.self, forKey: .message)) ?? ""
    }
}

struct NavidromeServerStatus: Codable {
    var subsonicresponse: SubsonicResponseStatus
    
    enum CodingKeys: String, CodingKey {
        case subsonicresponse = "subsonic-response"
    }
}

struct SubsonicResponseSearch: Codable {
    var searchResult2: SubsonicSearchResults
}

struct SubsonicSearchResults: Codable {
    var artist: [NDArtist]?
    var album: [NDAlbum]?
    var song: [NDSong]?
}

struct SubsonicAlbumResults: Codable {
    var album: [NDAlbum]?
}

struct SubsonicFetchedAlbum: Codable {
    var album: NDFetchedAlbum
}

struct SubsonicFetchedArtist: Codable {
    var artist: NDFetchedArtist
}

struct SubsonicAlbumList: Codable {
    var albumList: SubsonicAlbumResults
}

struct NDArtist: Codable {
    var id: String
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        name = (try? values?.decode(String.self, forKey: .name)) ?? ""
    }
}

struct NDFetchedArtist: Codable {
    var id: String
    var name: String
    var artistImageUrl: String
    var album: [NDFetchedArtistAlbum]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, artistImageUrl, album
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        name = (try? values?.decode(String.self, forKey: .name)) ?? ""
        artistImageUrl = (try? values?.decode(String.self, forKey: .artistImageUrl)) ?? ""
        album = (try? values?.decode([NDFetchedArtistAlbum].self, forKey: .album)) ?? []
    }
}

struct NDAlbum: Codable {
    var id: String
    var name: String
    var year: Int
    var coverArt: String
    var artists: [NDArtist]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, year, coverArt, artists
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        name = (try? values?.decode(String.self, forKey: .name)) ?? ""
        year = (try? values?.decode(Int.self, forKey: .year)) ?? 9999
        coverArt = (try? values?.decode(String.self, forKey: .coverArt)) ?? ""
        artists = (try? values?.decode([NDArtist].self, forKey: .artists)) ?? []
    }
}

struct NDFetchedAlbum: Codable {
    var id: String
    var name: String
    var year: Int
    var coverArt: String
    var artists: [NDArtist]
    var song: [NDSong]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, year, coverArt, artists, song
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        name = (try? values?.decode(String.self, forKey: .name)) ?? ""
        year = (try? values?.decode(Int.self, forKey: .year)) ?? 9999
        coverArt = (try? values?.decode(String.self, forKey: .coverArt)) ?? ""
        artists = (try? values?.decode([NDArtist].self, forKey: .artists)) ?? []
        song = (try? values?.decode([NDSong].self, forKey: .song)) ?? []
    }
}

struct NDFetchedArtistAlbum: Codable {
    var id: String
    var name: String
    var year: Int
    var coverArt: String
    var artists: [NDArtist]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, year, coverArt, artists
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        name = (try? values?.decode(String.self, forKey: .name)) ?? ""
        year = (try? values?.decode(Int.self, forKey: .year)) ?? 9999
        coverArt = (try? values?.decode(String.self, forKey: .coverArt)) ?? ""
        artists = (try? values?.decode([NDArtist].self, forKey: .artists)) ?? []
    }
}

struct NDSong: Codable {
    var id: String
    var title: String
    var album: String
    var track: Int
    var year: Int
    var coverArt: String
    var duration: Int
    var albumId: String
    var artists: [NDArtist]
    var albumArtists: [NDArtist]
    var explicitStatus: String // "explicit" or ""
    
    private enum CodingKeys: String, CodingKey {
        case id, title, album, track, year, coverArt, duration, albumId, artists, albumArtists, explicitStatus
    }
    
    init(from decoder: Decoder) {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? values?.decode(String.self, forKey: .id)) ?? ""
        title = (try? values?.decode(String.self, forKey: .title)) ?? ""
        album = (try? values?.decode(String.self, forKey: .album)) ?? ""
        track = (try? values?.decode(Int.self, forKey: .track)) ?? 0
        year = (try? values?.decode(Int.self, forKey: .year)) ?? 9999
        coverArt = (try? values?.decode(String.self, forKey: .coverArt)) ?? ""
        duration = (try? values?.decode(Int.self, forKey: .duration)) ?? 0
        albumId = (try? values?.decode(String.self, forKey: .albumId)) ?? ""
        artists = (try? values?.decode([NDArtist].self, forKey: .artists)) ?? []
        albumArtists = (try? values?.decode([NDArtist].self, forKey: .albumArtists)) ?? []
        explicitStatus = (try? values?.decode(String.self, forKey: .explicitStatus)) ?? ""
    }
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
    var song: NDSong
}
