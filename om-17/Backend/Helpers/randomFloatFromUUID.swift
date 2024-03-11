//
//  randomFloatFromUUID.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI
import GameplayKit
import Foundation

func uuidToUInt64(_ uuid: UUID) -> UInt64 {
    let uuidBytes = withUnsafeBytes(of: uuid.uuid) { Data($0) }
    let leastSignificantBytes = uuidBytes[8...15]
    var number: UInt64 = 0
    for byte in leastSignificantBytes {
        number = (number << 8) | UInt64(byte)
    }
    return number
}

class Random {
    var rs: GKLinearCongruentialRandomSource
    var seed: UUID
    init(_ seed: UUID) {
        self.seed = seed
        self.rs = GKLinearCongruentialRandomSource(seed: uuidToUInt64(seed))
    }
    
    func reset() {
        self.rs = GKLinearCongruentialRandomSource(seed: uuidToUInt64(self.seed))
    }
    
    /// returns a float in [0.0, 1.0]
    func next() -> Double {
        return Double(self.rs.nextUniform())
    }
}
