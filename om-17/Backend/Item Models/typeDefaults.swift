//
//  defaultTypes.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

func SearchResults_default() -> SearchResults {
    SearchResults(
        Tracks: [FetchedTrack(), FetchedTrack(), FetchedTrack()],
        Albums: [SearchedAlbum(), SearchedAlbum(), SearchedAlbum()],
        Singles: [SearchedAlbum(), SearchedAlbum(), SearchedAlbum()],
        Artists: [SearchedArtist(), SearchedArtist(), SearchedArtist()]
    )
}

func FetchedAlbum_default() -> FetchedAlbum {
    FetchedAlbum(from: [FetchedTrack(), FetchedTrack(), FetchedTrack(), FetchedTrack()])
}

func FetchedArtist_default() -> FetchedArtist {
    FetchedArtist(default: true)
}

func FetchedPlayback_default() -> FetchedPlayback {
    FetchedPlayback(PlaybackID: "", YT_Video_ID: "12345", YT_Audio_ID: "12345", Playback_Audio_URL: "youtube.com")
}

func StoredTrack_default() -> StoredTrack {
    StoredTrack(from: FetchedTrack())
}

func StoredAlbum_default() -> StoredAlbum {
    StoredAlbum(from: [StoredTrack_default(), StoredTrack_default(), StoredTrack_default(), StoredTrack_default()])
}

func SearchedPlaylist_default() -> SearchedPlaylist {
    SearchedPlaylist(Title: "Playlist Name")
}
