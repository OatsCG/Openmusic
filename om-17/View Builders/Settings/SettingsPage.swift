//
//  SettingsPage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-24.
//

import SwiftUI

struct SettingsPage: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(FontManager.self) private var fontManager
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
                    Text("Openmusic is not responsible for the content served by your server, including copyrighted music. Research your country's copyright laws before streaming. For help with servers, visit [create.openmusic.app](https://create.openmusic.app).")
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
                
//                NavigationLink(destination: NowPlayingOptions()) {
//                    Text("Now Playing")
//                }
                
                NavigationLink(destination: QueueOptions()) {
                    Text("Queue")
                }
                
                NavigationLink(destination: DebugOptions()) {
                    Text("Debug")
                }
                
                Section {
                    
                } footer: {
                    VStack(alignment: .leading, spacing: 15) {
                        Link(destination: URL(string: "https://ko-fi.com/charliegiannis")!) {
                            HStack {
                                Image(systemName: "cup.and.saucer")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(.trailing, 4)
                                    .bold()
                                Text("Support Me!")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .opacity(colorScheme == .dark ? 0.9 : 0.73)
                                    .customFont(fontManager, .body)
                            }
                            .padding(.leading, 8)
                            .padding(.trailing, 18)
                            .padding(.vertical, 8)
                            .background {
                                DonateBG()
                            }
                        }
                            .padding(.bottom, 4)
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text("openmusic inc.")
                                Text("2024 Charlie Giannis")
                                    .customFont(fontManager, .caption2)
                            }
                            Text("💜")
                                .hueRotation(.degrees(heartHue))
                                .onAppear {
                                    withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                                        heartHue = 360
                                    }
                                }
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
        .overlay {
            VStack {
                Spacer()
                MiniToasts()
                    .padding(.bottom, 5)
            }
        }
    }
}

struct DonateBG: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var buttonHue: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            colorScheme == .dark ? Color(red: 200 / 255, green: 255 / 255, blue: 220 / 255) : Color(red: 185 / 255, green: 255 / 255, blue: 200 / 255),
                            colorScheme == .dark ? Color(red: 200 / 255, green: 220 / 255, blue: 255 / 255) : Color(red: 185 / 255, green: 200 / 255, blue: 255 / 255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .hueRotation(.degrees(buttonHue))
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: colorScheme == .dark ? [.black.opacity(0.3), .black.opacity(0.7)] : [.white.opacity(0.7), .white.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                .stroke(Color(red: 255 / 255, green: 210 / 255, blue: 230 / 255).opacity(0.8), lineWidth: 1)
                .hueRotation(.degrees(buttonHue))
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                buttonHue = 360
            }
        }
    }
}

#Preview {
    SettingsPage()
        .environment(PlayerManager())
        .environment(DownloadManager())
}
