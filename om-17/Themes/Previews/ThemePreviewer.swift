//
//  ThemePreview_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI
//import SwiftData

struct ThemeSelection: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @State var albumLocStart: CGPoint = CGPointMake(0.5, 0.5)
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Appearance", selection: $preferredAppearance) {
                    ForEach(Appearance.allCases, id: \.self) { option in
                        Text(option.rawValue.capitalized).tag(option.rawValue)
                    }
                }
                .pickerStyle(.palette)
                .safeAreaPadding()
                ThemePreviews()
            }
            .background {
                GlobalBackground_component()
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Themes")
    }
}


struct ThemePreviews: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    // tracks
    @State var track1: FetchedTrack = FetchedTrack(default: true)
    @State var track2: FetchedTrack = FetchedTrack(default: true)
    @State var track3: FetchedTrack = FetchedTrack(default: true)
    @State var track4: FetchedTrack = FetchedTrack(default: true)
    @State var track5: FetchedTrack = FetchedTrack(default: true)
    @State var track6: FetchedTrack = FetchedTrack(default: true)
    @State var track7: FetchedTrack = FetchedTrack(default: true)
    @State var pm: PlayerManager = PlayerManager(dormant: true)
    @State var dot1: CGFloat = 0.3
    @State var dot2: CGFloat = 0.3
    @State var dot3: CGFloat = 0.3
    @State var dot4: CGFloat = 0.3
    @State var dot5: CGFloat = 0.3
    @State var dot6: CGFloat = 0.3
    @State var timer: Timer? = nil
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(1...6, id: \.self) { i in
                            Group {
                                if i == 1 {
                                    ThemePreview_classic(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot1)
                                        .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                                        .environment(FontManager(currentlyChosenTheme: .classic))
                                } else if i == 2 {
                                    ThemePreview_honeycrisp(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot2)
                                        .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                                        .environment(FontManager(currentlyChosenTheme: .honeycrisp))
                                } else if i == 3 {
                                    ThemePreview_wii(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot3)
                                        .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                                        .environment(FontManager(currentlyChosenTheme: .wii))
                                } else if i == 4 {
                                    ThemePreview_spotty(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot4)
                                        .environment(\.colorScheme, .dark)
                                        .environment(FontManager(currentlyChosenTheme: .spotty))
                                } else if i == 5 {
                                    ThemePreview_faero(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot5)
                                        .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                                        .environment(FontManager(currentlyChosenTheme: .faero))
                                } else if i == 6 {
                                    ThemePreview_feco(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7, dot: $dot6)
                                        .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                                        .environment(FontManager(currentlyChosenTheme: .feco))
                                }
                            }
                            .frame(width: max(geo.size.width - 60, 0))
                            .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                view.scaleEffect(phase.isIdentity ? 1: 0.90)
                            }
                            .tag(i)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 30)
                }
                .scrollIndicators(.never)
                .scrollTargetBehavior(.viewAligned)
                .environment(pm)
                //.frame(height: 700)
                .tabViewStyle(PageTabViewStyle())
                .task {
                    switch currentTheme {
                    case "classic":
                        proxy.scrollTo(1, anchor: .leading)
                    case "honeycrisp":
                        proxy.scrollTo(2, anchor: .leading)
                    case "wii":
                        proxy.scrollTo(3, anchor: .leading)
                    case "spotty":
                        proxy.scrollTo(4, anchor: .leading)
                    case "faero":
                        proxy.scrollTo(5, anchor: .leading)
                    case "feco":
                        proxy.scrollTo(6, anchor: .leading)
                    default:
                        proxy.scrollTo(1, anchor: .leading)
                    }
                }
            }
            HStack(alignment: .center, spacing: 5) {
                ForEach(1...6, id: \.self) { i in
                    Group {
                        if i == 1 {
                            Circle().fill(.primary)
                                .opacity(dot1)
                        } else if i == 2 {
                            Circle().fill(.primary)
                                .opacity(dot2)
                                .frame(width: 8, height: 8)
                        } else if i == 3 {
                            Circle().fill(.primary)
                                .opacity(dot3)

                        } else if i == 4 {
                            Circle().fill(.primary)
                                .opacity(dot4)
                        } else if i == 5 {
                            Circle().fill(.primary)
                                .opacity(dot5)
                        } else if i == 6 {
                            Circle().fill(.primary)
                                .opacity(dot6)
                        }
                    }
                        .frame(width: 8, height: 8)
                }
            }
            .position(x: geo.size.width * 0.5, y: geo.size.height * 0.95)
        }
        //.safeAreaPadding()
        .onAppear {
            for index in 1...7 {
                if index == 1 {
                    track1 = findRandomTrack()
                } else if index == 2 {
                    track2 = findRandomTrack()
                } else if index == 3 {
                    track3 = findRandomTrack()
                } else if index == 4 {
                    track4 = findRandomTrack()
                } else if index == 5 {
                    track5 = findRandomTrack()
                } else if index == 6 {
                    track6 = findRandomTrack()
                } else if index == 7 {
                    track7 = findRandomTrack()
                    pm.currentQueueItem = QueueItem(from: track7, explicit: nil)
                    pm.update_timer(to: 5)
                }
            }
            updateTrackTimer()
        }
    }
    func updateTrackTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            runUpdateTracks()
            
        }
    }
    func runUpdateTracks() {
        for index in 1...7 {
            updateTrack(index: index)
        }
    }
    
    func updateTrack(index: Int) {
        self.timer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.0...2.0), repeats: false) { _ in
            withAnimation {
                if index == 1 {
                    track1 = findRandomTrack()
                } else if index == 2 {
                    track2 = findRandomTrack()
                } else if index == 3 {
                    track3 = findRandomTrack()
                } else if index == 4 {
                    track4 = findRandomTrack()
                } else if index == 5 {
                    track5 = findRandomTrack()
                } else if index == 6 {
                    track6 = findRandomTrack()
                } else if index == 7 {
                    track7 = findRandomTrack()
                    pm.currentQueueItem = QueueItem(from: track7, explicit: nil)
                    pm.update_timer(to: 5)
                }
            }
        }
    }
    
    func findRandomTrack() -> FetchedTrack {
        let chosenTrack: FetchedTrack? = RecentlyPlayedManager.getRecentTracks().randomElement()
        if let chosenTrack = chosenTrack {
            return chosenTrack
        } else {
            return FetchedTrack(default: true)
        }
    }
}


#Preview {
    @Previewable @AppStorage("customFonts") var customFonts: Bool = true
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
//    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

//    let playlist = StoredPlaylist(Title: "Test!")
//    container.mainContext.insert(playlist)
    
    return ThemeSelection()
//        .modelContainer(container)
        .environment(PlayerManager())
//        .environment(PlaylistImporter())
//        .environment(DownloadManager())
        .environment(FontManager.shared)
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
        }
}
