//
//  NotificationManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-27.
//

@preconcurrency import SwiftUI

final class NotificationManager: Sendable {
    let center = UNUserNotificationCenter.current()
    
    init() {
        setupNotificationCategories()
    }

    private func setupNotificationCategories() {
        let action1 = UNNotificationAction(identifier: "SKIP_ACTION", title: "Skip", options: [])
        // let action2 = UNNotificationAction(identifier: "PAUSE_ACTION", title: "Pause", options: [])

        let category = UNNotificationCategory(identifier: "SKIP_CATEGORY", actions: [action1], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func scheduleNotification(track: any Track) {
        let content = UNMutableNotificationContent()
//        content.title = "Now Playing"
//        content.subtitle = track.Title
//        content.body = "By \(stringArtists(artistlist: track.Album.Artists))"
        content.title = track.Title
        content.body = "By \(stringArtists(artistlist: track.Album.Artists))"
        //content.categoryIdentifier = "SKIP_CATEGORY"
        downloadAlbumArt(ArtworkID: track.Album.Artwork) { localURL in
            if let localURL = localURL,
               let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: localURL, options: nil) {
                content.attachments = [attachment]

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .leastNonzeroMagnitude, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                if (UserDefaults.standard.bool(forKey: "SkipNotifyEnabled")) {
                    self.center.add(request)
                }
            }
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the delegate on launch
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification actions
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier

//        switch actionIdentifier {
//        case "SKIP_ACTION":
//            handleActionOne()
//        case "PAUSE_ACTION":
//            handleActionTwo()
//        default:
//            break
//        }

        completionHandler()
    }

    private func handleActionOne() {
        // Define what ACTION_ONE should do
        print("Action One Triggered")
    }

    private func handleActionTwo() {
        // Define what ACTION_TWO should do
        print("Action Two Triggered")
    }
}
