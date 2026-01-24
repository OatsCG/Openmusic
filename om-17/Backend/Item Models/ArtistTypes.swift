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
    
    init(ArtistID: String, Name: String, Profile_Photo: String, Subscribers: Int) {
        self.ArtistID = ArtistID
        self.Name = Name
        self.Profile_Photo = Profile_Photo
        self.Subscribers = Subscribers
    }
    
    init() {
        ArtistID = UUID().uuidString
        Name = ""
        Profile_Photo = ""
        Subscribers = 0
    }
    
    init(default: Bool) {
        ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        Name = "Don Toliver"
        Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        Subscribers = 1750000
    }
    
    init(from: Bool) {
        ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        Name = "Don Toliver"
        Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        Subscribers = 1750000
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
        ArtistID = "-1"
        Name = ""
        Profile_Photo = ""
        Subscribers = 9999
        Albums = []
        Singles = []
        Tracks = []
    }
    
    init(ArtistID: String, Name: String, Profile_Photo: String, Subscribers: Int, Albums: [SearchedAlbum], Singles: [SearchedAlbum], Tracks: [FetchedTrack]) {
        self.ArtistID = ArtistID
        self.Name = Name
        self.Profile_Photo = Profile_Photo
        self.Subscribers = Subscribers
        self.Albums = Albums
        self.Singles = Singles
        self.Tracks = Tracks
    }
    
    init(default: Bool) {
        ArtistID = "UCSzWQmDsKG37iKN2vw1G-2Q"
        Name = "Don Toliver"
        Profile_Photo = "iPLK-SftNUxhdxy5-_g6_o_-r6faLLlCP4UebYWQwF-r2SSsTB2iM59h7EPJTLPP8rmsCYsfD2zIb4Y"
        Subscribers = 1750000
        Albums = []
        Singles = []
        Tracks = []
    }
}
