//
//  GatherArtists.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-09.
//

import Foundation

func groupArtists(tracks: [StoredTrack]) -> ([SearchedArtist : [FetchedAlbum]], [SearchedArtist : [StoredTrack]]) {
    //var artists: [String] = []
    var albumDict: [SearchedArtist:[StoredTrack]] = [:]
    var featuresDict: [SearchedArtist:[StoredTrack]] = [:]
    for track in tracks {
        for feature in track.Features {
            if featuresDict[feature] == nil {
                featuresDict[feature] = []
            }
            featuresDict[feature]!.append(track)
        }
        for artist in track.Album.Artists {
            if albumDict[artist] == nil {
                albumDict[artist] = []
            }
            albumDict[artist]!.append(track)
        }
    }
    
    var artistAlbums: [SearchedArtist:[FetchedAlbum]] = [:]
    for artist in albumDict.keys {
        artistAlbums[artist] = []
        
        let artistTracks: [StoredTrack] = albumDict[artist]!
        
        let albumTracksUnsorted = Array(Dictionary(grouping: artistTracks, by: { $0.Album.AlbumID }).values)
        
        let albumTracks = albumTracksUnsorted.sorted{$0.sorted{$0.dateAdded > $1.dateAdded}[0].dateAdded > $1.sorted{$0.dateAdded > $1.dateAdded}[0].dateAdded}
        
        for artistAlbum in albumTracks {
            artistAlbums[artist]!.append(FetchedAlbum(from: artistAlbum.sorted{$0.Index < $1.Index}))
        }
    }
    
    return (artistAlbums, featuresDict)
}
