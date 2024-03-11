//
//  estEqual.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-21.
//

import SwiftUI

func estEqual(_ x: Float, _ y: Float) -> Bool {
    if abs(y - x) < 0.000001 {
        return true
    }
    return false
}
func estEqual(_ x: Double, _ y: Double) -> Bool {
    if abs(y - x) < 0.000001 {
        return true
    }
    return false
}


func mod(_ a: Double, _ n: Double) -> Double {
    precondition(n > 0, "modulus must be positive")
    let r = a.truncatingRemainder(dividingBy: n)
    return r >= 0 ? r : r + n
}
