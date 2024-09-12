////
////  PMAFadeControls.swift
////  om-17
////
////  Created by Charlie Giannis on 2024-08-28.
////
//
//import SwiftUI
//
//extension PlayerManagerActor {
//    func play_fade() async {
//        self.setIsPlaying(to: true)
//        self.player.playImmediately()
//        self.startingVol = self.player.volume()
//        
//        self.total_fade_steps = Int((UserDefaults.standard.double(forKey: "playerFadeSeconds") + 0.05) * 100) // Calculate steps based on duration, here it's assuming the time unit is in seconds
//        if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
//            
//            
//            for currentFadeStep in 0..<self.total_fade_steps {
//                let to = self.startingVol + (self.appVolume - self.startingVol) * (Float(currentFadeStep) / Float(self.total_fade_steps))
//                self.player.set_volume(to: pow(to, 2))
//                try? await Task.sleep(for: .seconds(0.01))
//            }
//        } else {
//            let to = self.appVolume
//            self.player.set_volume(to: to)
//        }
//    }
//    
//    func pause_fade() async {
//        self.setIsPlaying(to: false)
//        self.total_fade_steps = Int(UserDefaults.standard.double(forKey: "playerFadeSeconds") * 100)
//        self.startingVol = self.player.volume()
//        
//        if (UserDefaults.standard.double(forKey: "playerFadeSeconds") != 0) {
//            
//            for currentFadeStep in 0..<self.total_fade_steps {
//                let to = self.startingVol - self.startingVol * (Float(currentFadeStep) / Float(self.total_fade_steps))
//                self.player.set_volume(to: pow(to, 2))
//                try? await Task.sleep(for: .seconds(0.01))
//            }
//            print("PAUSED AT #4")
//            self.player.pause()
//
//        } else {
//
//            self.player.set_volume(to: 0)
//            print("PAUSED AT #5")
//            self.player.pause()
//        }
//    }
//}
