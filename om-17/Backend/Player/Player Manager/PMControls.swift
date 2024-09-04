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
        }
    }
    
    func pause() {
        Task {
            await self.PMActor.pause()
        }
    }
    
    func player_forward(continueCurrent: Bool = false, userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerForward(continueCurrent: continueCurrent, userInitiated: userInitiated)
        }
    }
    
    func player_backward(userInitiated: Bool = false) {
        Task {
            await self.PMActor.playerBackward(userInitiated: userInitiated)
        }
    }
    
    func setIsPlaying(to: Bool) {
        if self.isPlaying != to {
            Task {
                await self.PMActor.setIsPlaying(to: to)
            }
            withAnimation(.bouncy) {
                self.isPlaying = to
            }
        }
    }
}
