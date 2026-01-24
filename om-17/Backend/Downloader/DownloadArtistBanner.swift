//
//  downloadArtistBanner.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

func BuildArtistBannerURL(imgID: String?, resolution: Resolution, aspectRatio: Double) -> URL? {
    guard let imgID else { return nil }
    if let url = isValidURL(imgID) {
        return url
    }
    return URL(string: NetworkManager.shared.networkService.getEndpointURL(.image(id: imgID, w: resolution.rawValue, h: resolution.rawValue)))
}

func ArtistBannerExists(ArtworkID: String) -> Bool {
    if let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Banner-\(ArtworkID).jpg"),
       FileManager.default.fileExists(atPath: destination.path) {
        return true
    }
    return false
}
