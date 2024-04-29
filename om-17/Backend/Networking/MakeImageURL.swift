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
    case background = 60
    case blur = 80
    case cookie = 120
    case tile = 480
    case hd = 1920
}
