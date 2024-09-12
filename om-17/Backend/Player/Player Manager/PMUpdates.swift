//
//  PMUpdates.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-06.
//

import Foundation
import SwiftUI

extension PlayerManager {
    func updateUI(userInitiated: Bool = true) {
        // NON-DETACHED WORKS, detached does not reach IN TASK
        Task {
            await self.PMActor.setAppVolume(to: self.appVolume)
            let isPlaying = await self.PMActor.isPlaying
            let elapsedTime = await self.PMActor.elapsedTime
            let durationSeconds = await self.PMActor.durationSeconds
            let elapsedNormal = await self.PMActor.elapsedNormal
            let currentQueueItem = await self.PMActor.currentQueueItem
            let trackQueue = await self.PMActor.trackQueue
            let sessionHistory = await self.PMActor.sessionHistory
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: userInitiated ? 0.2 : 0.4)) {
                    self.isPlaying = isPlaying
                    self.elapsedTime = elapsedTime
                    self.durationSeconds = durationSeconds
                    self.elapsedNormal = elapsedNormal
                    self.currentQueueItem = currentQueueItem
                    self.trackQueue = trackQueue
                    self.sessionHistory = sessionHistory
                }
            }
        }
    }
    
    func isPlayingUpdateUI(_ to: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.isPlaying = to
        }
    }
    func elapsedTimeUpdateUI(_ to: Double) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.elapsedTime = to
        }
    }
    func durationSecondsUpdateUI(_ to: Double) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.durationSeconds = to
        }
    }
    func elapsedNormalUpdateUI(_ to: Double) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.elapsedNormal = to
        }
    }
}
