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
        self.isPlayingUpdateUI(true)
        Task {
            await self.PMActor.play()
            self.addSuggestions()
            self.updateUI()
        }
    }
    
    func pause() {
        self.isPlayingUpdateUI(false)
        Task {
            print("PAUSED AT #6")
            await self.PMActor.pause()
            self.updateUI()
        }
    }
    
    func player_forward(continueCurrent: Bool = false, userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerForward(continueCurrent: continueCurrent, userInitiated: userInitiated)
            self.updateUI()
        }
    }
    
    func player_backward(userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerBackward(userInitiated: userInitiated)
            self.updateUI()
        }
    }
    
    func seek(to: Double) {
        Task {
            await self.PMActor.player.seek(to: to)
            self.updateUI()
        }
    }
    
    func setIsPlaying(to: Bool) {
        if self.isPlaying != to {
            Task {
                await self.PMActor.setIsPlaying(to: to)
                self.updateUI()
            }
            withAnimation(.bouncy) {
                self.isPlaying = to
            }
        }
    }
}
