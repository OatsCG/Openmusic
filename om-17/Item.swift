//
//  Item.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-05.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
