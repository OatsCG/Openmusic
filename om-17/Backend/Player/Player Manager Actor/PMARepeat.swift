//
//  PMARepeat.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI


extension PlayerManagerActor {
    func repeat_check() async {
        if (self.didAddFromRepeat || self.repeatMode == .off) {
            return
        }
        let timeRemaining: Double = self.durationSeconds - self.elapsedTime - self.crossfadeSeconds
        if await self.currentQueueItem?.isReady ?? false && timeRemaining < 5 {
            if self.currentQueueItem != nil {
                self.didAddFromRepeat = true
                if self.repeatMode == .single {
                    await single_repeat_add()
                } else if self.repeatMode == .queue {
                    await queue_repeat_add()
                }
            }
        }
    }
    
    func single_repeat_add() async {
        // add copy of current song to front of queue
        
        let newQueueItem: QueueItem = await QueueItem(from: self.currentQueueItem!)
        await self.queue_next(queueItem: newQueueItem)
    }
    
    func queue_repeat_add() async {
        if (self.trackQueue.count == 0 && self.currentQueueItem != nil) {
            // if queue is empty: move history to queue and clear history
            self.trackQueue = self.sessionHistory
            self.reset_session_history()
            // add copy of current song to end of queue
            if (self.trackQueue.count == 0) {
                let newQueueItem: QueueItem = await QueueItem(from: self.currentQueueItem!)
                await self.queue_song(queueItem: newQueueItem)
            }
        }
    }
}
