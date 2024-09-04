//
//  PMANotifications.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-28.
//

import SwiftUI

extension PlayerManagerActor {
    func scheduleNotification() async {
        if let currentQueueItem = self.currentQueueItem {
            await self.notificationManager.scheduleNotification(track: currentQueueItem.Track)
        }
    }
}
