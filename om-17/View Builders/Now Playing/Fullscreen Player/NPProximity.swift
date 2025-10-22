//
//  NPProximityTeller.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-07.
//

import SwiftUI

struct NPProximity: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("proximityHorizontalColumn") var proximityHorizontalColumn: Double = 0.5
    @AppStorage("proximityVerticalRange") var proximityVerticalRange: Double = 1
    var proximityManager: ProximityManager = ProximityManager()
    let capturetimer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        EmptyView()
        .onReceive(capturetimer) { time in
            proximityManager.extractCenterPixel(row: Float(proximityHorizontalColumn), range: proximityVerticalRange, completion: { centerDepth in
                if let centerDepth {
                    playerManager.depth_change_detected(close: centerDepth.good)
                }
            })
        }
        .onDisappear {
            proximityManager.stopRunning()
        }
    }
}
