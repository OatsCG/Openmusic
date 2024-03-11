//
//  MakeImageURL.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation


func BuildArtistCookieImageURL(imgID: String, resolution: Resolution) -> URL? {
    let url = URL(string:"https://lh3.googleusercontent.com/\(imgID)=w\(resolution.rawValue)-h\(resolution.rawValue)-p-l90-rj")
    return url ?? nil
}

enum Resolution: Int {
    case background = 120
    case blur = 220
    case cookie = 240
    case tile = 480
    case hd = 1920
}
