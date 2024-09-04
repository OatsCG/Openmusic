//
//  PMRepeat.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-14.
//

import SwiftUI
import AVFoundation

extension PlayerManager {
    func cycle_repeat_mode() {
        withAnimation {
            if (self.repeatMode == .off) {
                self.setRepeatMode(to: .queue)
            } else if (self.repeatMode == .queue) {
                self.setRepeatMode(to: .single)
            } else {
                self.setRepeatMode(to: .off)
            }
        }
    }
    
    
    
}


enum RepeatMode: String, Identifiable, CaseIterable {
    case off, queue, single
    var id: Self { self }
}

