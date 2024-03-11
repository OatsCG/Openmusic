//
//  FetchedTypes.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import SwiftUI

struct SearchedArtist: Codable, Hashable {
    var ArtistID: String
    var Name: String
    var Profile_Photo: String
    var Subscribers: Int
    
    init() {
        self.ArtistID = UUID().uuidString
        self.Name = ""
        self.Profile_Photo = ""
        self.Subscribers = 0
    }
    init(default: Bool) {
        self.ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        self.Name = "Don Toliver"
        self.Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        self.Subscribers = 1750000
    }
    init(from: Bool) {
        self.ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        self.Name = "Don Toliver"
        self.Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        self.Subscribers = 1750000
    }
}

struct FetchedArtist: Codable, Hashable {
    var ArtistID: String
    var Name: String
    var Profile_Photo: String
    var Subscribers: Int
    var Albums: [SearchedAlbum]
    var Singles: [SearchedAlbum]
    var Tracks: [FetchedTrack]
    
    init() {
        self.ArtistID = "-1"
        self.Name = ""
        self.Profile_Photo = ""
        self.Subscribers = 9999
        self.Albums = []
        self.Singles = []
        self.Tracks = []
    }
    
    init(default: Bool) {
        self.ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        self.Name = "Don Toliver"
        self.Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        self.Subscribers = 1750000
        self.Albums = []
        self.Singles = []
        self.Tracks = []
    }
}
