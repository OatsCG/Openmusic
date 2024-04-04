//
//  SettingsPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-24.
//

import SwiftUI
// 142.189.12.151

struct SettingsPage: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("downloadsCount") var downloadsCount: Int = 8
    @State var heartHue: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    CustomServerInput()
                } header: {
                    Text("NETWORKING")
                } footer: {
                    Text("Openmusic is not responsible for the content served by community servers, including copyrighted music. Research your country's copyright laws before streaming. For help with servers, check out [openmusic.app](https://openmusic.app).")
                }
                
                NavigationLink(destination: ThemingOptions()) {
                    VStack(alignment: .leading) {
                        Text("Themes")
                        Text(themeName(theme: currentTheme))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                NavigationLink(destination: PlaybackOptions()) {
                    Text("Playback")
                }
                
                NavigationLink(destination: ControlsOptions()) {
                    Text("Custom Controls")
                }
                
                NavigationLink(destination: NotificationOptions()) {
                    Text("Notifications")
                }
                
                NavigationLink(destination: NowPlayingOptions()) {
                    Text("Now Playing")
                }
                
                NavigationLink(destination: QueueOptions()) {
                    Text("Queue")
                }
                
                NavigationLink(destination: DebugOptions()) {
                    Text("Debug")
                }
                
                Section {
                    
                } footer: {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text("openmusic inc.")
                                Text("2024 Charlie Giannis")
                                    .customFont(.caption2)
                            }
//                            NavigationLink(destination: Credits()) {
//                                HStack(spacing: 5) {
//                                    Text("Made with")
                                    Text("💜")
                                        .hueRotation(.degrees(heartHue))
                                        .onAppear {
                                            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                                                heartHue = 360
                                            }
                                        }
//                                    Image(systemName: "chevron.right.circle.fill")
//                                        .font(.headline)
//                                        .symbolRenderingMode(.hierarchical)
//                                }
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 4)
//                                    .background(.ultraThinMaterial)
//                                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                            }
//                                .buttonStyle(.plain)
                        }
                        Text("To report a bug or suggest a feature, email [help@openmusic.app](mailto:help@openmusic.app).")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .background {
                GlobalBackground_component()
            }
        }
    }
}

#Preview {
    SettingsPage()
        .environment(PlayerManager())
        .environment(DownloadManager())
}
