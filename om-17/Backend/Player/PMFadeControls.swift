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
        self.play_fade_timer?.invalidate()
        self.pause_fade_timer?.invalidate()
        self.startingVol = self.player.volume()
        self.total_fade_steps = Int((UserDefaults.standard.double(forKey: "playerFadeSeconds") + 0.05) * 100) // Calculate steps based on duration, here it's assuming the time unit is in seconds
        self.current_fade_step = 0
        if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                self.play_fade_timer?.invalidate()
                self.pause_fade_timer?.invalidate()
                self.play_fade_timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [unowned self] playTimer in
                    DispatchQueue.main.async { [unowned self] in
                        self.current_fade_step += 1
                        let to = self.startingVol + (self.appVolume - self.startingVol) * (Float(self.current_fade_step) / Float(self.total_fade_steps))
                        self.player.set_volume(to: pow(to, 2))
                        if self.current_fade_step >= self.total_fade_steps {
                            self.play_fade_timer?.invalidate()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let to = self.appVolume
                self.player.set_volume(to: to)
                self.play_fade_timer?.invalidate()
            }
        }
    }
    func pause_fade() {
        DispatchQueue.main.async {
            self.setIsPlaying(to: false)
        }
        self.play_fade_timer?.invalidate()
        self.pause_fade_timer?.invalidate()
        self.current_fade_step = 0
        self.total_fade_steps = Int(UserDefaults.standard.double(forKey: "playerFadeSeconds") * 100)
        self.startingVol = self.player.volume()
        Task { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
                    self.pause_fade_timer?.invalidate()
                    self.pause_fade_timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [unowned self] playTimer in
                        DispatchQueue.main.async { [unowned self] in
                            self.current_fade_step += 1
                            let to = self.startingVol - self.startingVol * (Float(self.current_fade_step) / Float(self.total_fade_steps))
                            self.player.set_volume(to: pow(to, 2))
                            if self.current_fade_step >= self.total_fade_steps {
                                self.pause_fade_timer?.invalidate()
                                self.pause_fade_timer = nil
                                self.player.pause()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        self.player.set_volume(to: 0)
                        self.pause_fade_timer?.invalidate()
                        self.player.pause()
                    }
                }
            }
        }
    }
}
