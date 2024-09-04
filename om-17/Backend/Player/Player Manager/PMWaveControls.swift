//
//  PMWaveControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-09.
//

import SwiftUI

extension PlayerManager {
    func depth_change_detected(close: Bool) {
        Task {
            await self.PMActor.depth_change_detected(close: close)
            await self.updateUI()
        }

    }
}
