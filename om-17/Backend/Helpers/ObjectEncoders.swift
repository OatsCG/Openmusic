//
//  ObjectEncoders.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-07.
//

import SwiftUI

func encodeAlbumToURLSafeString(album: SearchedAlbum) -> String? {
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(album),
       let jsonString = String(data: jsonData, encoding: .utf8) {
        return jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    return nil
}

func decodeURLSafeStringToAlbum(encodedString: String) -> SearchedAlbum? {
    if let decodedString = encodedString.removingPercentEncoding,
       let jsonData = decodedString.data(using: .utf8) {
        return try? NetworkManager.shared.networkService.decodeSearchedAlbum(jsonData)
    }
    return nil
}
