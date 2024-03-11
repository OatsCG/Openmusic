//
//  DepthConverter.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-12.
//

import SwiftUI

func convertDepthDistance(x: Float) -> Float {
    if (x.isNaN) {
        return 1
    } else {
        return 0
    }
}
