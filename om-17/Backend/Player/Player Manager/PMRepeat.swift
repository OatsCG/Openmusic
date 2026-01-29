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
            if repeatMode == .off {
                repeatMode = .queue
            } else if repeatMode == .queue {
                repeatMode = .single
            } else {
                repeatMode = .off
            }
        }
    }
    
    func repeat_check() {
        if didAddFromRepeat || repeatMode == .off {
            return
        }
        let timeRemaining = durationSeconds - elapsedTime - crossfadeSeconds
        if let currentQueueItem, currentQueueItem.isReady(self) && timeRemaining < 5 {
            didAddFromRepeat = true
            if repeatMode == .single {
                single_repeat_add()
            } else if repeatMode == .queue {
                queue_repeat_add()
            }
        }
    }
    
    func single_repeat_add() {
        // add copy of current song to front of queue
        if let currentQueueItem {
            withAnimation {
                queue_next(queueItem: QueueItem(from: currentQueueItem))
            }
        }
    }
    
    func queue_repeat_add() {
        if trackQueue.isEmpty, let currentQueueItem {
            // if queue is empty: move history to queue and clear history
            withAnimation {
                trackQueue = sessionHistory
                reset_session_history()
            }
            // add copy of current song to end of queue
            if trackQueue.isEmpty {
                withAnimation {
                    queue_song(queueItem: QueueItem(from: currentQueueItem))
                }
            }
        }
    }
}

enum RepeatMode: String, Identifiable, CaseIterable {
    case off, queue, single
    var id: Self { self }
}
