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
        if (self.volumeSkipEnabled == false) {
            return
        }
        
        let changeDate = Date().timeIntervalSince1970
        //best: self.volumeSkipSpeed = 0.3
        //best: self.volumeSkipMargin = 0.6
        if oldValue != nil && newValue != nil {
            if self.lastVolume == nil {
                // new volume session
                self.lastVolume = (oldValue!, newValue!, changeDate, true)
            } else if changeDate > self.lastVolume!.2 + self.volumeSkipMargin {
                // new volume session
                self.lastVolume = (oldValue!, newValue!, changeDate, true)
            } else if changeDate < self.lastVolume!.2 + self.volumeSkipSpeed {
                // second click in session
                // if consecutive clicks line up:
                if newValue! == self.lastVolume!.0 && self.lastVolume!.3 == true {
                    let difference = oldValue! - newValue!
                    if estEqual(difference, 0.0625) {
                        self.player_backward(userInitiated: true)
                    }
                    if estEqual(difference, -0.0625) {
                        self.player_forward(userInitiated: true)
                    }
                    self.lastVolume = (oldValue!, newValue!, changeDate, false)
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
