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
                self.repeatMode = .queue
            } else if (self.repeatMode == .queue) {
                self.repeatMode = .single
            } else {
                self.repeatMode = .off
            }
        }
    }
    
    func repeat_check() {
        if (self.didAddFromRepeat || self.repeatMode == .off) {
            return
        }
        let timeRemaining: Double = self.durationSeconds - self.elapsedTime - self.crossfadeSeconds
        if (self.currentQueueItem?.isReady() ?? false && timeRemaining < 5) {
            if self.currentQueueItem != nil {
                self.didAddFromRepeat = true
                if self.repeatMode == .single {
                    single_repeat_add()
                } else if self.repeatMode == .queue {
                    queue_repeat_add()
                }
            }
        }
    }
    
    func single_repeat_add() {
        // add copy of current song to front of queue
        let newQueueItem: QueueItem = QueueItem(from: self.currentQueueItem!)
        withAnimation {
            self.queue_next(queueItem: newQueueItem)
        }
    }
    
    func queue_repeat_add() {
        if (self.trackQueue.count == 0 && self.currentQueueItem != nil) {
            // if queue is empty: move history to queue and clear history
            withAnimation {
                self.trackQueue = self.sessionHistory
                self.reset_session_history()
            }
            // add copy of current song to end of queue
            if (self.trackQueue.count == 0) {
                let newQueueItem: QueueItem = QueueItem(from: self.currentQueueItem!)
                withAnimation {
                    self.queue_song(queueItem: newQueueItem)
                }
            }
        }
    }
    
}


enum RepeatMode: String, Identifiable, CaseIterable {
    case off, queue, single
    var id: Self { self }
}

