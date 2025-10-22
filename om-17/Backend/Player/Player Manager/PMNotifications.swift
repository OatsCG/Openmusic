//
//  PMNotifications.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-27.
//

import SwiftUI

extension PlayerManager {
    @MainActor func scheduleNotification() {
        if let currentQueueItem {
            notificationManager.scheduleNotification(track: currentQueueItem.Track)
        }
    }
}

