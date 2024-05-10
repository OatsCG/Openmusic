//
//  DownloadEnums.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-12.
//

import SwiftUI
import SwiftData

enum DownloadState: Identifiable, Codable {
    case inactive, waiting, fetching, downloading, success, cancelled, error
    var id: Self { self }
}
