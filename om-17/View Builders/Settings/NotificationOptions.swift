//
//  NotificationOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-30.
//

import SwiftUI

struct NotificationOptions: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("SkipNotifyEnabled") var SkipNotifyEnabled: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    Toggle("Push Now Playing", isOn: $SkipNotifyEnabled)
                        .onChange(of: SkipNotifyEnabled) { oldValue, newValue in
                            if (newValue == true) {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        print("All set!")
                                    } else if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            playerManager.SkipNotifyEnabled = SkipNotifyEnabled
                        }
                        .tint(.green)
                }, header: {
                    Text("NOTIFICATIONS")
                }, footer: {
                    Text("Push a \"Now Playing\" notification when you skip a song. Customize lock screen persistence in Settings>Notifications")
                })
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    NotificationOptions()
}
