//
//  PMPlayer.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    
    func change_volume(to: Float) {
        self.appVolume = to
        Task {
            await self.PMActor.setVolume(to: self.appVolume)
            await self.updateUI()
        }
    }
    
    func switchCurrentlyPlaying(queueItem: QueueItem) async {
        await self.PMActor.switchCurrentlyPlaying(queueItem: queueItem)
        self.addSuggestions()
    }
}
