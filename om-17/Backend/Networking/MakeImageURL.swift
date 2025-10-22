//
//  MakeImageURL.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation


func BuildArtistCookieImageURL(imgID: String, resolution: Resolution) -> URL? {
    URL(string: NetworkManager.shared.networkService.getEndpointURL(.image(id: imgID, w: resolution.rawValue, h: resolution.rawValue)))
}

enum Resolution: Int {
    case background = 60
    case blur = 80
    case cookie = 120
    case tile = 480
    case hd = 1920
}
