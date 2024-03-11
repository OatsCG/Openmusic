//
//  RecognizePlaylist.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-01.
//

import Foundation

func recognizePlaylist(url: String) -> (platform: Platform, id: String) {
    if (url.contains("music.apple.com")) {
        let id: String = url.components(separatedBy: "/").last!
        return(.apple, id)
    } else if (url.contains("spotify.com")) {
        let id: String = url.components(separatedBy: "/").last!.components(separatedBy: "?").first!
        return(.spotify, id)
    }
    return(.unknown, "")
}

func getItemsMatching(items: [PlaylistItem], status: [ImportStatus]) -> [PlaylistItem] {
    let matchedItems: [PlaylistItem] = items.filter{status.contains($0.importData.status)}
    return(matchedItems)
}

func itemInPlaylist(playlist: Playlist, track: any Track) -> Bool {
    for item in playlist.items {
        if (item.track.TrackID == track.TrackID) {
            return true
        }
    }
    return false
}



/*
 https://music.apple.com/ca/playlist/beatstrumentals/pl.f54198ad42404535be13eabf3835fb22
 https://music.apple.com/ca/playlist/driving/pl.u-NpXmDMaImRe2EGP
 https://music.apple.com/ca/playlist/favs/pl.u-NpXmzl3I40jxJMW
 https://music.apple.com/ca/playlist/heard-in-apple-ads/pl.b28c3a5975b04436b42680595f6983ad
 
 https://open.spotify.com/playlist/7IcCCwOjy2ZMINPPIGHcgf?si=9b6809d80dbb41dc&nd=1&dlsi=3cf1ca72fa0743c2
 https://open.spotify.com/playlist/7IcCCwOjy2ZMINPPIGHcgf
 https://open.spotify.com/playlist/7IcCCwOjy2ZMINPPIGHcgf?si=4e7229535b114643
 https://open.spotify.com/playlist/37i9dQZF1DWXT8uSSn6PRy?si=-s1Z7Ox3SXGkWwDE94lEHA
 
 
 
 
 */
