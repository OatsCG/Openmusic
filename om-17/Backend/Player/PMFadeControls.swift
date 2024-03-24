//
//  PMFadeControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-15.
//

import SwiftUI

extension PlayerManager {
    func play_fade() {
        DispatchQueue.main.async {
            self.setIsPlaying(to: true)
        }
        self.player.playImmediately()
        self.play_fade_timer.invalidate()
        self.pause_fade_timer.invalidate()
        let startingVol = self.player.volume()
        let steps = Int((UserDefaults.standard.double(forKey: "playerFadeSeconds") + 0.05) * 100) // Calculate steps based on duration, here it's assuming the time unit is in seconds
        var step = 0
        if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.play_fade_timer.invalidate()
                self.pause_fade_timer.invalidate()
                self.play_fade_timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] playTimer in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        step += 1
                        let to = startingVol + (self.appVolume - startingVol) * (Float(step) / Float(steps))
                        self.player.set_volume(to: pow(to, 2))
                        if step >= steps {
                            self.play_fade_timer.invalidate()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let to = self.appVolume
                self.player.set_volume(to: to)
                self.play_fade_timer.invalidate()
            }
        }
    }
    func pause_fade() {
        DispatchQueue.main.async {
            self.setIsPlaying(to: false)
        }
        self.play_fade_timer.invalidate()
        self.pause_fade_timer.invalidate()
        let startingVol = self.player.volume()
        let steps = Int(UserDefaults.standard.double(forKey: "playerFadeSeconds") * 100) // Calculate steps based on duration, here it's assuming the time unit is in seconds
        var step = 0
        if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
            self.pause_fade_timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] pauseTimer in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    step += 1
                    let to = startingVol - startingVol * (Float(step) / Float(steps))
                    self.player.set_volume(to: pow(to, 2))
                    if step >= steps {
                        self.pause_fade_timer.invalidate()
                        self.player.pause()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.player.set_volume(to: 0)
                self.pause_fade_timer.invalidate()
                self.player.pause()
            }
        }
    }
}
