//
//  PMNotifications.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-27.
//

import SwiftUI

extension PlayerManager {
    @MainActor func scheduleNotification() {
        if self.currentQueueItem != nil {
            self.notificationManager.scheduleNotification(track: self.currentQueueItem!.Track)
        }
    }

    
}

