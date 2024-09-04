//
//  PMControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func play() {
        Task {
            await self.PMActor.play()
            self.addSuggestions()
            await self.updateUI()
        }
    }
    
    func pause() {
        Task {
            await self.PMActor.pause()
            await self.updateUI()
        }
    }
    
    func player_forward(continueCurrent: Bool = false, userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerForward(continueCurrent: continueCurrent, userInitiated: userInitiated)
            await self.updateUI()
        }
    }
    
    func player_backward(userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerBackward(userInitiated: userInitiated)
            await self.updateUI()
        }
    }
    
    func seek(to: Double) {
        Task {
            await self.PMActor.player.seek(to: to)
            await self.updateUI()
        }
    }
    
    func setIsPlaying(to: Bool) {
        if self.isPlaying != to {
            Task {
                await self.PMActor.setIsPlaying(to: to)
                await self.updateUI()
            }
            withAnimation(.bouncy) {
                self.isPlaying = to
            }
        }
    }
}
