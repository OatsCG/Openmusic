////
////  PMAWaveControls.swift
////  om-17
////
////  Created by Charlie Giannis on 2024-08-28.
////
//
//import SwiftUI
//
//extension PlayerManagerActor {
//    func depth_change_detected(close: Bool) async {
//        let sessionDelay = 0.8
//        let hoverMax = 0.3
//        let waveMax = 0.2
//        
//        let changeDate = Date().timeIntervalSince1970
//        let lastDepth = self.lastWaveDepth.0
//        let lastTime = self.lastWaveDepth.1
//        let isValid = self.lastWaveDepth.2
//        if close {
//            if lastDepth == false {
//                if changeDate - lastTime > sessionDelay {
//                    self.lastWaveDepth = (true, changeDate, true)
//                } else {
//                    self.lastWaveDepth = (true, changeDate, false)
//                }
//            } else {
//                if changeDate - lastTime > hoverMax && isValid {
//                    self.lastWaveDepth = (true, changeDate, false)
//                    if self.isPlaying {
//                        await self.pause()
//                    } else {
//                        await self.play()
//                    }
//                }
//            }
//        }
//
//        if !close {
//            if lastDepth == true {
//                if changeDate - lastTime < waveMax && isValid {
//                    self.lastWaveDepth = (false, changeDate, false)
//                    await self.playerForward(userInitiated: true)
//                } else {
//                    self.lastWaveDepth = (false, changeDate, false)
//                }
//            }
//        }
//
//    }
//}
