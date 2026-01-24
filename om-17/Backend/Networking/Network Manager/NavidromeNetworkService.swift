//
//  NavidromeNetworkService.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-23.
//

import Foundation

class NavidromeNetworkService: NetworkService {
    var supportedFeatures: [ServerFeature] = [.quicksearch]
    
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
    
    /// For use in the New Server page
    func getEndpointURL(_ endpoint: Endpoint, ip: String) -> String {
        return switch endpoint {
        case .status:
            "\(ip)/rest/ping?\(params)&u=\(u)&p=\(p)"
        default:
            "\(ip)/rest/ping?\(params)&u=\(u)&p=\(p)"
        }
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        return switch endpoint {
        case .status:
            "\(baseURL())/rest/ping?\(params)&u=\(u)&p=\(p)"
        case .explore:
            "\(baseURL())/rest/getAlbumList?\(params)&u=\(u)&p=\(p)&type=newest"
        case .vibes:  // TODO:
            "\(baseURL())/rest/ping?\(params)&u=\(u)&p=\(p)"
        case .search(q: let q):
            "\(baseURL())/rest/search2?\(params)&u=\(u)&p=\(p)&any=\(q)"
        case .quick(q: let q):  // TODO:
            "\(baseURL())/rest/ping?\(params)&u=\(u)&p=\(p)"
        case .album(id: let id):
            "\(baseURL())/rest/getAlbum?\(params)&u=\(u)&p=\(p)&id=\(id)"
        case .artist(id: let id):
            "\(baseURL())/rest/getArtist?\(params)&u=\(u)&p=\(p)&id=\(id)"
        case .random: // TODO:
            "\(baseURL())/rest/ping?\(params)&u=\(u)&p=\(p)"
        case .playback(id: let id):
            "\(baseURL())/rest/getSong?\(params)&u=\(u)&p=\(p)&id=\(id)"
        case .image(id: let id, w: _, h: let h):
            "\(baseURL())/rest/getCoverArt?\(params)&u=\(u)&p=\(p)&id=\(id)&size=\(h)"
        default:
            "\(baseURL())/rest/ping?\(params)&u=\(u)&p=\(p)"
        }
    }
    
    func decodeServerStatus(_ data: Data) throws -> ServerStatus {
        let d = try decoder.decode(NavidromeServerStatus.self, from: data)
        return ServerStatus(online: d.subsonicresponse.error == nil, title: "", body: "", footer: "", om_verify: "ok", type: .navidrome)
    }
    
    func decodeExploreResults(_ data: Data) throws -> ExploreResults {
        let d = try decoder.decode(NavidromeAlbumList.self, from: data)
        var albums: [SearchedAlbum] = []
        for album in d.subsonicresponse.albumList.album {
            var albumArtists: [SearchedArtist] = []
            for artist in album.albumArtists {
                albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
            }
            albums.append(SearchedAlbum(AlbumID: album.id, Title: album.album, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: albumArtists))
        }
        return ExploreResults(Shelves: [ExploreShelf(Title: "Albums", Albums: albums)])
    }
    
    func decodeVibeShelf(_ data: Data) throws -> VibeShelf {
        return VibeShelf(vibes: [])
    }
    
    func decodeSearchResults(_ data: Data) throws -> SearchResults {
        let d = try decoder.decode(NavidromeSearch.self, from: data)
        
        var tracks: [FetchedTrack] = []
        var albums: [SearchedAlbum] = []
        var artists: [SearchedArtist] = []
        
        for t in d.subsonicresponse.searchResult2.song {
            var albumArtists: [SearchedArtist] = []
            for artist in t.albumArtists {
                albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
            }
            
            let album = SearchedAlbum(AlbumID: t.albumId, Title: t.album, Artwork: t.coverArt, AlbumType: "Album", Year: t.year, Artists: albumArtists)
            var features: [SearchedArtist] = []
            for artist in t.artists {
                features.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
            }
            
            tracks.append(FetchedTrack(TrackID: t.id, Title: t.title, Playback_Clean: t.id, Playback_Explicit: nil, Length: t.duration, Index: t.track, Views: 0, Album: album, Features: features))
        }
        
        for album in d.subsonicresponse.searchResult2.album {
            var albumArtists: [SearchedArtist] = []
            for artist in album.albumArtists {
                albumArtists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
            }
            albums.append(SearchedAlbum(AlbumID: album.id, Title: album.album, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: albumArtists))
        }
        
        for artist in d.subsonicresponse.searchResult2.artist {
            artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: artist.artistImageUrl, Subscribers: 0))
        }
        
        return SearchResults(Tracks: tracks, Albums: albums, Singles: [], Artists: artists)
    }
    
    func decodeFetchedTracks(_ data: Data) throws -> FetchedTracks {
        return FetchedTracks(Tracks: [])
    }
    
    func decodeFetchedAlbum(_ data: Data) throws -> FetchedAlbum {
        let d = try decoder.decode(NavidromeFetchedAlbum.self, from: data)
        let s = d.subsonicresponse
        var artists: [SearchedArtist] = []
        var tracks: [FetchedTrack] = []
        
        for artist in s.album.artists {
            artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
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
                artists.append(SearchedArtist(ArtistID: artist.id, Name: artist.name, Profile_Photo: "", Subscribers: 0))
            }
            albums.append(SearchedAlbum(AlbumID: album.id, Title: album.name, Artwork: album.coverArt, AlbumType: "Album", Year: album.year, Artists: artists))
        }
        
        return FetchedArtist(ArtistID: d.subsonicresponse.artist.id, Name: d.subsonicresponse.artist.name, Profile_Photo: d.subsonicresponse.artist.artistImageUrl, Subscribers: 0, Albums: albums, Singles: [], Tracks: [])
    }
    
    func decodeRandomTracks(_ data: Data) throws -> RandomTracks {
        return RandomTracks(Tracks: [])
    }
    
    func decodeFetchedPlaylistInfo(_ data: Data) throws -> FetchedPlaylistInfo {
        return FetchedPlaylistInfo()
    }
    
    func decodeFetchedPlaylistInfoTracks(_ data: Data) throws -> FetchedPlaylistInfoTracks {
        return FetchedPlaylistInfoTracks()
    }
    
    func decodeImportedTracks(_ data: Data) throws -> ImportedTracks {
        return ImportedTracks(Tracks: [])
    }
    
    func decodeFetchedPlayback(_ data: Data) throws -> FetchedPlayback {
        let d = try decoder.decode(NavidromeSong.self, from: data)
        print("ND: GOT PLAYBACK \("\(baseURL())/rest/stream?\(params)&u=\(u)&p=\(p)&id=\(d.subsonicresponse.song.id)")")
        return FetchedPlayback(PlaybackID: d.subsonicresponse.song.id, YT_Audio_ID: "", Playback_Audio_URL: "\(baseURL())/rest/stream?\(params)&u=\(u)&p=\(p)&id=\(d.subsonicresponse.song.id)")
    }
    
    func decodeSearchedAlbum(_ data: Data) throws -> SearchedAlbum {
        return SearchedAlbum()
    }
    
    func decodeFetchedTrack(_ data: Data) throws -> FetchedTrack {
        return FetchedTrack()
    }
}
