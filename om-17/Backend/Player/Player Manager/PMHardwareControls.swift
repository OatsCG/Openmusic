//
//  PMHardwareControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-19.
//

import AVFoundation
import SwiftUI

extension PlayerManager {
    func volume_control_check(oldValue: Float?, newValue: Float?) {
        guard volumeSkipEnabled else { return }
        
        let changeDate = Date().timeIntervalSince1970
        //best: self.volumeSkipSpeed = 0.3
        //best: self.volumeSkipMargin = 0.6
        if let oldValue, let newValue {
            if lastVolume == nil {
                // new volume session
                lastVolume = (oldValue, newValue, changeDate, true)
            } else if let lastVolume, changeDate > lastVolume.2 + volumeSkipMargin {
                // new volume session
                self.lastVolume = (oldValue, newValue, changeDate, true)
            } else if let lastVolume, changeDate < lastVolume.2 + volumeSkipSpeed {
                // second click in session
                // if consecutive clicks line up:
                if newValue == lastVolume.0 && lastVolume.3 {
                    let difference = oldValue - newValue
                    if estEqual(difference, 0.0625) {
                        player_backward(userInitiated: true)
                    }
                    if estEqual(difference, -0.0625) {
                        player_forward(userInitiated: true)
                    }
                    self.lastVolume = (oldValue, newValue, changeDate, false)
                }
            }
        }
    }
    
    func volume_up_pressed() {
        print("volume UP")
    }
    
    func volume_down_pressed() {
        print("volume DOWN")
    }
}
