//
//  NavidromeNetworkService.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-23.
//

import Foundation
import CryptoKit

class NavidromeNetworkService: @preconcurrency NetworkService {
    var supportedFeatures: [ServerFeature] = [.quicksearch, .scrobble]
    
    var u: String
    var p: String
    let params: String = "f=json&v=1.8.0&c=openmusic"
    let decoder = JSONDecoder()
    
    init(u: String, p: String) {
        self.u = u
        self.p = p
    }
    
    init() {
        u = ""
        p = ""
    }
    
    func baseURL() -> String {
        return NetworkManager.globalIPAddress()
    }
    
    func creds() -> String {
        let hash: String = md5Hash(input: p, salt: "openmusic")
        return "u=\(u)&t=\(hash)&s=\("openmusic")"
    }
    
    private func md5Hash(input: String, salt: String) -> String {
        let combined = input + salt
        let data = Data(combined.utf8)
        
        let digest = Insecure.MD5.hash(data: data)
        
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// For use in the New Server page
    func getEndpointURL(_ endpoint: Endpoint, ip: String) -> String {
        return switch endpoint {
        case .status:
            "\(ip)/rest/ping?\(params)&\(creds())"
        default:
            "\(ip)/rest/ping?\(params)&\(creds())"
        }
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        return switch endpoint {
        case .status:
            "\(baseURL())/rest/ping?\(params)&\(creds())"
        case .explore:
            "\(baseURL())/rest/getAlbumList?\(params)&\(creds())&type=newest&size=50"
        case .search(q: let q):
            "\(baseURL())/rest/search2?\(params)&\(creds())&query=\(q)&artistCount=50&albumCount=50&songCount=50"
        case .quick(q: let q):
            "\(baseURL())/rest/search2?\(params)&\(creds())&query=\(q)&artistCount=0&albumCount=0&songCount=20"
        case .album(id: let id):
            "\(baseURL())/rest/getAlbum?\(params)&\(creds())&id=\(id)"
        case .artist(id: let id):
            "\(baseURL())/rest/getArtist?\(params)&\(creds())&id=\(id)"
        case .playback(id: let id):
            "\(baseURL())/rest/getSong?\(params)&\(creds())&id=\(id)"
        case .image(id: let id, w: _, h: let h):
            "\(baseURL())/rest/getCoverArt?\(params)&\(creds())&id=\(id)&size=\(h)"
        case .scrobble(id: let id, enjoyed: let enjoyed):
            "\(baseURL())/rest/scrobble?\(params)&\(creds())&id=\(id)&time=\(Date().timeIntervalSince1970)&submission=\(enjoyed ? "true" : "false")"
        default:
            "\(baseURL())/rest/ping?\(params)&\(creds())"
        }
    }
    
    func decodeServerStatus(_ data: Data) throws -> ServerStatus {
        let d = try decoder.decode(NavidromeServerStatus.self, from: data)
        var serverStatus = ServerStatus(online: d.subsonicresponse.error == nil, title: "Navidrome Server", body: "version \(d.subsonicresponse.serverVersion)", footer: "", om_verify: "ok", type: .navidrome)
        if let error = d.subsonicresponse.error {
            serverStatus.body = error.message
            serverStatus.footer = "Error code \(error.code)"
            serverStatus.om_verify = "bad"
        }
        return serverStatus
    }
    
    func decodeExploreResults(_ data: Data) throws -> ExploreResults {
        let d = try decoder.decode(NavidromeAlbumList.self, from: data)
        guard let dalbum = d.subsonicresponse.albumList.album else { return ExploreResults(Shelves: []) }
        var albums: [SearchedAlbum] = []
        for album in dalbum {
            var albumArtists: [SearchedArtist] = []
            for artist in album.artists {
                albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
            }
            albums.append(SearchedAlbum(AlbumID: album.id, Title: album.name, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: albumArtists))
        }
        return ExploreResults(Shelves: [ExploreShelf(Title: "Albums", Albums: albums)])
    }
    
    func decodeVibeShelf(_ data: Data) throws -> VibeShelf {
        throw NetworkServiceError.notImplementedError("VibeShelf not implemented.")
    }
    
    func decodeSearchResults(_ data: Data) throws -> SearchResults {
        let d = try decoder.decode(NavidromeSearch.self, from: data)
        var tracks: [FetchedTrack] = []
        var albums: [SearchedAlbum] = []
        var artists: [SearchedArtist] = []
        
        if let dsong = d.subsonicresponse.searchResult2.song {
            for t in dsong {
                var albumArtists: [SearchedArtist] = []
                for artist in t.albumArtists {
                    albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
                }
                
                let album = SearchedAlbum(AlbumID: t.albumId, Title: t.album, Artwork: t.coverArt, AlbumType: "Album", Year: t.year, Artists: albumArtists)
                var features: [SearchedArtist] = []
                for artist in t.artists {
                    features.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
                }
                
                tracks.append(FetchedTrack(TrackID: t.id, Title: t.title, Playback_Clean: t.id, Playback_Explicit: nil, Length: t.duration, Index: t.track, Views: 0, Album: album, Features: features))
            }
        }
        
        if let dalbum = d.subsonicresponse.searchResult2.album {
            for album in dalbum {
                var albumArtists: [SearchedArtist] = []
                for artist in album.artists {
                    albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
                }
                albums.append(SearchedAlbum(AlbumID: album.id, Title: album.name, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: albumArtists))
            }
        }
        
        if let dartist = d.subsonicresponse.searchResult2.artist {
            for artist in dartist {
                artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
            }
        }
        
        return SearchResults(Tracks: tracks, Albums: albums, Singles: [], Artists: artists)
    }
    
    func decodeFetchedTracks(_ data: Data) throws -> FetchedTracks {
        let d = try decoder.decode(NavidromeSearch.self, from: data)
        
        var tracks: [FetchedTrack] = []
        
        if let dsong = d.subsonicresponse.searchResult2.song {
            for t in dsong {
                var albumArtists: [SearchedArtist] = []
                for artist in t.albumArtists {
                    albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
                }
                
                let album = SearchedAlbum(AlbumID: t.albumId, Title: t.album, Artwork: t.coverArt, AlbumType: "Album", Year: t.year, Artists: albumArtists)
                var features: [SearchedArtist] = []
                for artist in t.artists {
                    features.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
                }
                
                tracks.append(FetchedTrack(TrackID: t.id, Title: t.title, Playback_Clean: t.id, Playback_Explicit: nil, Length: t.duration, Index: t.track, Views: 0, Album: album, Features: features))
            }
        }
        
        return FetchedTracks(Tracks: tracks)
    }
    
    func decodeFetchedAlbum(_ data: Data) throws -> FetchedAlbum {
        let d = try decoder.decode(NavidromeFetchedAlbum.self, from: data)
        let s = d.subsonicresponse
        var artists: [SearchedArtist] = []
        var tracks: [FetchedTrack] = []
        
        for artist in s.album.artists {
            artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
        }
        let album = SearchedAlbum(AlbumID: s.album.id, Title: s.album.name, Artwork: s.album.coverArt, AlbumType: "Album", Year: s.album.year, Artists: artists)
        for song in s.album.song {
            tracks.append(FetchedTrack(TrackID: song.id, Title: song.title, Playback_Clean: song.id, Playback_Explicit: nil, Length: song.duration, Index: song.track, Views: 0, Album: album, Features: []))
        }
        
        return FetchedAlbum(AlbumID: s.album.id, Title: s.album.name, Artwork: s.album.coverArt, AlbumType: "Album", Year: s.album.year, Artists: artists, Tracks: tracks, Features: [])
    }
    
    func decodeFetchedArtist(_ data: Data) throws -> FetchedArtist {
        let d = try decoder.decode(NavidromeFetchedArtist.self, from: data)
        var albums: [SearchedAlbum] = []
        for album in d.subsonicresponse.artist.album {
            var artists: [SearchedArtist] = []
            for artist in album.artists {
                artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.id, Subscribers: 0))
            }
            albums.append(SearchedAlbum(AlbumID: album.id, Title: album.name, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: artists))
        }
        
        return FetchedArtist(ArtistID: d.subsonicresponse.artist.id, Name: d.subsonicresponse.artist.name, Profile_Photo: d.subsonicresponse.artist.artistImageUrl, Subscribers: 0, Albums: albums, Singles: [], Tracks: [])
    }
    
    func decodeRandomTracks(_ data: Data) throws -> RandomTracks {
        throw NetworkServiceError.notImplementedError("RandomTracks not implemented.")
    }
    
    func decodeFetchedPlaylistInfo(_ data: Data) throws -> FetchedPlaylistInfo {
        throw NetworkServiceError.notImplementedError("FetchedPlaylistInfo not implemented.")
    }
    
    func decodeFetchedPlaylistInfoTracks(_ data: Data) throws -> FetchedPlaylistInfoTracks {
        throw NetworkServiceError.notImplementedError("FetchedPlaylistInfoTracks not implemented.")
    }
    
    func decodeImportedTracks(_ data: Data) throws -> ImportedTracks {
        throw NetworkServiceError.notImplementedError("ImportedTracks not implemented.")
    }
    
    @MainActor func decodeFetchedPlayback(_ data: Data) throws -> FetchedPlayback {
        let d = try decoder.decode(NavidromeSong.self, from: data)
        var currentBitRate: Int = 0
        if UserDefaults.standard.bool(forKey: "streamBitrateEnabled") && NetworkMonitor.shared.currentPath == .cellular {
            currentBitRate = Int(UserDefaults.standard.double(forKey: "streamBitrateCellular"))
            return FetchedPlayback(PlaybackID: d.subsonicresponse.song.id, YT_Audio_ID: "", Playback_Audio_URL: "\(baseURL())/rest/stream?\(params)&\(creds())&id=\(d.subsonicresponse.song.id)&maxBitRate=\(currentBitRate)&format=mp3")
        } else {
            return FetchedPlayback(PlaybackID: d.subsonicresponse.song.id, YT_Audio_ID: "", Playback_Audio_URL: "\(baseURL())/rest/stream?\(params)&\(creds())&id=\(d.subsonicresponse.song.id)")
        }
    }
    
    func decodeSearchedAlbum(_ data: Data) throws -> SearchedAlbum {
        return SearchedAlbum()
    }
    
    func decodeFetchedTrack(_ data: Data) throws -> FetchedTrack {
        return FetchedTrack()
    }
}
