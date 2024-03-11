//
//  StringArtists.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-11.
//

import Foundation

func stringArtists(artistlist: [SearchedArtist]) -> String {
    var artistNames: [String] = []
    if (artistlist.count == 0) {
        return ""
    }
    for x in artistlist {
        artistNames.append(x.Name)
    }
    return artistNames.joined(separator: ", ")
}
