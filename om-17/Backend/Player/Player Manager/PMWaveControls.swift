//
//  PMWaveControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-09.
//

import SwiftUI

extension PlayerManager {
    func depth_change_detected(close: Bool) {
        let sessionDelay = 0.8
        let hoverMax = 0.3
        let waveMax = 0.2
        
        let changeDate = Date().timeIntervalSince1970
        let lastDepth = lastWaveDepth.0
        let lastTime = lastWaveDepth.1
        let isValid = lastWaveDepth.2
        if close {
            if !lastDepth {
                if changeDate - lastTime > sessionDelay {
                    lastWaveDepth = (true, changeDate, true)
                } else {
                    lastWaveDepth = (true, changeDate, false)
                }
            } else {
                if changeDate - lastTime > hoverMax && isValid {
                    lastWaveDepth = (true, changeDate, false)
                    if is_playing() {
                        pause()
                    } else {
                        play()
                    }
                }
            }
        }

        if !close {
            if lastDepth {
                if changeDate - lastTime < waveMax && isValid {
                    lastWaveDepth = (false, changeDate, false)
                    player_forward(userInitiated: true)
                } else {
                    lastWaveDepth = (false, changeDate, false)
                }
            }
        }
    }
}
