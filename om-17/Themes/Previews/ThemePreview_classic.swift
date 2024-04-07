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
                ThemePreviews()
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
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    // tracks
    @State var track1: FetchedTrack = FetchedTrack(default: true)
    @State var track2: FetchedTrack = FetchedTrack(default: true)
    @State var track3: FetchedTrack = FetchedTrack(default: true)
    @State var track4: FetchedTrack = FetchedTrack(default: true)
    @State var track5: FetchedTrack = FetchedTrack(default: true)
    @State var track6: FetchedTrack = FetchedTrack(default: true)
    @State var track7: FetchedTrack = FetchedTrack(default: true)
    @State var pm: PlayerManager = PlayerManager()
    var body: some View {
        GeometryReader { geo in
            TabView {
            //ScrollView(.horizontal) {
                ThemePreview_classic(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7)
                    .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                    .environment(pm)
                    .environment(FontManager(currentlyChosenTheme: .classic))
                    .frame(width: geo.size.width * 1)
                ThemePreview_spotty(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7)
                    //.forceCustomFont(.callout, theme: .spotty)
                    .environment(\.colorScheme, .dark)
                    .environment(pm)
                    .environment(FontManager(currentlyChosenTheme: .spotty))
                    .frame(width: geo.size.width * 1)
                ThemePreview_classic(track1: $track1, track2: $track2, track3: $track3, track4: $track4, track5: $track5, track6: $track6, track7: $track7)
                    .environment(\.colorScheme, preferredAppearance == "dark" ? .dark : (preferredAppearance == "light" ? .light : colorScheme))
                    .environment(pm)
                    .environment(FontManager(currentlyChosenTheme: .classic))
                    .frame(width: geo.size.width * 1)
            }
            //.frame(height: 700)
            .tabViewStyle(PageTabViewStyle())
            //.scrollTargetBehavior(.paging)
            //.scrollIndicators(.never)
        }
        .safeAreaPadding()
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
                }
                updateTrack(index: index)
            }
        }
    }
    func updateTrack(index: Int) {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 3.0...5.0), repeats: false) { _ in
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
                }
            }
            updateTrack(index: index)
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

struct ThemePreview_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @State var parallax: CGFloat = 0
    // input tracks
    @Binding var track1: FetchedTrack
    @Binding var track2: FetchedTrack
    @Binding var track3: FetchedTrack
    @Binding var track4: FetchedTrack
    @Binding var track5: FetchedTrack
    @Binding var track6: FetchedTrack
    @Binding var track7: FetchedTrack
    // Positions
    var songLinkPos: CGPoint = CGPointMake(0.65, 0.1)
    var playButtonPos: CGPoint = CGPointMake(0.2, 0.11)
    var backButtonPos: CGPoint = CGPointMake(0.85, 0.2)
    var trackLinkPos: CGPoint = CGPointMake(0.38, 0.21)
    var titlePos: CGPoint = CGPointMake(0.5, 0.33)
    var albumLinkPos: CGPoint = CGPointMake(0.175, 0.55)
    var recentAlbumPos: CGPoint = CGPointMake(0.66, 0.53)
    var miniplayerPos: CGPoint = CGPointMake(0.5, 0.72)
    var selectButtonPos: CGPoint = CGPointMake(0.5, 0.87)
    // Parallaxes
    var songLinkParallax: CGFloat = 60
    var playButtonParallax: CGFloat = 40
    var backButtonParallax: CGFloat = 25
    var trackLinkParallax: CGFloat = 10
    var titleParallax: CGFloat = 140
    var albumLinkParallax: CGFloat = 55
    var recentAlbumParallax: CGFloat = 20
    var miniplayerParallax: CGFloat = 40
    var selectButtonParallax: CGFloat = 5
    // Sizes
    var songLinkSize: CGFloat = 0.8
    var playButtonSize: CGFloat = 0.7
    var backButtonSize: CGFloat = 0.7
    var trackLinkSize: CGFloat = 0.65
    var titleSize: CGFloat = 1.6
    var albumLinkSize: CGFloat = 0.6
    var recentAlbumSize: CGFloat = 0.55
    var miniplayerSize: CGFloat = 0.7
    // opacities
    var songLinkOpacity: CGFloat = 0.82
    var playButtonOpacity: CGFloat = 0.72
    var backButtonOpacity: CGFloat = 0.72
    var trackLinkOpacity: CGFloat = 0.82
    var titleOpacity: CGFloat = 1
    var albumLinkOpacity: CGFloat = 0.82
    var recentAlbumOpacity: CGFloat = 0.82
    var miniplayerOpacity: CGFloat = 0.82
    var body: some View {
        GeometryReader { geo in
            SearchTrackLink_spotty(track: track1)
                .disabled(true)
                .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .compositingGroup()
                .scaleEffect(songLinkSize)
                .opacity(songLinkOpacity)
                .position(
                    x: (geo.size.width * songLinkPos.x) + (songLinkParallax * parallax),
                    y: (geo.size.height * songLinkPos.y)
                )
            NPPlayButton_spotty()
                .disabled(true)
                .scaleEffect(playButtonSize)
                .opacity(playButtonOpacity)
                .position(
                    x: (geo.size.width * playButtonPos.x) + (playButtonParallax * parallax),
                    y: (geo.size.height * playButtonPos.y)
                )
            TrackLink_spotty(track: track2)
                .disabled(true)
                .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
                .compositingGroup()
                .scaleEffect(trackLinkSize)
                .opacity(trackLinkOpacity)
                .position(
                    x: (geo.size.width * trackLinkPos.x) + (trackLinkParallax * parallax),
                    y: (geo.size.height * trackLinkPos.y)
                )
            NPBackButton_spotty()
                .disabled(true)
                .scaleEffect(backButtonSize)
                .opacity(backButtonOpacity)
                .position(
                    x: (geo.size.width * backButtonPos.x) + (backButtonParallax * parallax),
                    y: (geo.size.height * backButtonPos.y)
                )
            
            Text("Spotty")
                .forceCustomFont(.largeTitle, bold: true, theme: .spotty)
                .scaleEffect(titleSize)
                .opacity(titleOpacity)
                .position(
                    x: (geo.size.width * titlePos.x) + (titleParallax * parallax),
                    y: (geo.size.height * titlePos.y)
                )
            
            QPMultipleLink_spotty(tracks: [track3, track4, track5])
                .disabled(true)
                .scaleEffect(recentAlbumSize)
                .opacity(recentAlbumOpacity)
                .position(
                    x: (geo.size.width * recentAlbumPos.x) + (recentAlbumParallax * parallax),
                    y: (geo.size.height * recentAlbumPos.y)
                )
            
            SearchAlbumLink_spotty(album: track1.Album)
                .disabled(true)
                .frame(height: 200)
                .scaleEffect(albumLinkSize)
                .opacity(albumLinkOpacity)
                .position(
                    x: (geo.size.width * albumLinkPos.x) + (albumLinkParallax * parallax),
                    y: (geo.size.height * albumLinkPos.y)
                )
            
            MiniPlayer_spotty()
                .disabled(true)
                .scaleEffect(miniplayerSize)
                .opacity(miniplayerOpacity)
                .position(
                    x: (geo.size.width * miniplayerPos.x) + (miniplayerParallax * parallax),
                    y: (geo.size.height * miniplayerPos.y)
                )
            
            Button(action: {
                withAnimation {
                    currentTheme = "spotty"
                    FontManager.shared.currentlyChosenTheme = .spotty
                }
            }) {
                AlbumWideButton_spotty(text: currentTheme == "spotty" ? "Selected" : "Select", ArtworkID: "")
                    .frame(width: 200)
            }
                .foregroundStyle(currentTheme == "spotty" ? .secondary : .primary)
                .buttonStyle(.plain)
                .position(
                    x: (geo.size.width * selectButtonPos.x) + (selectButtonParallax * parallax),
                    y: (geo.size.height * selectButtonPos.y)
                )
                .onChange(of: geo.frame(in: .global).minX) { oldValue, newValue in
                    parallax = geo.frame(in: .global).minX / geo.frame(in: .global).width
                }
            
            
        }
        .background {
            GlobalBackground_spotty()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}



struct ThemePreview_classic: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @State var parallax: CGFloat = 0
    // input tracks
    @Binding var track1: FetchedTrack
    @Binding var track2: FetchedTrack
    @Binding var track3: FetchedTrack
    @Binding var track4: FetchedTrack
    @Binding var track5: FetchedTrack
    @Binding var track6: FetchedTrack
    @Binding var track7: FetchedTrack
    // Positions
    var songLinkPos: CGPoint = CGPointMake(0.65, 0.1)
    var playButtonPos: CGPoint = CGPointMake(0.2, 0.11)
    var backButtonPos: CGPoint = CGPointMake(0.85, 0.2)
    var trackLinkPos: CGPoint = CGPointMake(0.38, 0.21)
    var titlePos: CGPoint = CGPointMake(0.5, 0.33)
    var albumLinkPos: CGPoint = CGPointMake(0.175, 0.55)
    var recentAlbumPos: CGPoint = CGPointMake(0.66, 0.53)
    var miniplayerPos: CGPoint = CGPointMake(0.5, 0.72)
    var selectButtonPos: CGPoint = CGPointMake(0.5, 0.87)
    // Parallaxes
    var songLinkParallax: CGFloat = 60
    var playButtonParallax: CGFloat = 40
    var backButtonParallax: CGFloat = 25
    var trackLinkParallax: CGFloat = 10
    var titleParallax: CGFloat = 140
    var albumLinkParallax: CGFloat = 55
    var recentAlbumParallax: CGFloat = 20
    var miniplayerParallax: CGFloat = 40
    var selectButtonParallax: CGFloat = 5
    // Sizes
    var songLinkSize: CGFloat = 0.8
    var playButtonSize: CGFloat = 0.7
    var backButtonSize: CGFloat = 0.7
    var trackLinkSize: CGFloat = 0.65
    var titleSize: CGFloat = 1.6
    var albumLinkSize: CGFloat = 0.6
    var recentAlbumSize: CGFloat = 0.55
    var miniplayerSize: CGFloat = 0.7
    // opacities
    var songLinkOpacity: CGFloat = 0.82
    var playButtonOpacity: CGFloat = 0.72
    var backButtonOpacity: CGFloat = 0.72
    var trackLinkOpacity: CGFloat = 0.82
    var titleOpacity: CGFloat = 1
    var albumLinkOpacity: CGFloat = 0.82
    var recentAlbumOpacity: CGFloat = 0.82
    var miniplayerOpacity: CGFloat = 0.82
    var body: some View {
        GeometryReader { geo in
            SearchTrackLink_classic(track: track1)
                .disabled(true)
                .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .compositingGroup()
                .scaleEffect(songLinkSize)
                .opacity(songLinkOpacity)
                .position(
                    x: (geo.size.width * songLinkPos.x) + (songLinkParallax * parallax),
                    y: (geo.size.height * songLinkPos.y)
                )
            NPPlayButton_classic()
                .disabled(true)
                .scaleEffect(playButtonSize)
                .opacity(playButtonOpacity)
                .position(
                    x: (geo.size.width * playButtonPos.x) + (playButtonParallax * parallax),
                    y: (geo.size.height * playButtonPos.y)
                )
            TrackLink_classic(track: track2)
                .disabled(true)
                .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
                .compositingGroup()
                .scaleEffect(trackLinkSize)
                .opacity(trackLinkOpacity)
                .position(
                    x: (geo.size.width * trackLinkPos.x) + (trackLinkParallax * parallax),
                    y: (geo.size.height * trackLinkPos.y)
                )
            NPBackButton_classic()
                .disabled(true)
                .scaleEffect(backButtonSize)
                .opacity(backButtonOpacity)
                .position(
                    x: (geo.size.width * backButtonPos.x) + (backButtonParallax * parallax),
                    y: (geo.size.height * backButtonPos.y)
                )
            
            Text("Classic")
                //.forceCustomFont(.largeTitle, bold: true, theme: .classic)
                .font(.largeTitle .bold())
                .scaleEffect(titleSize)
                .opacity(titleOpacity)
                .position(
                    x: (geo.size.width * titlePos.x) + (titleParallax * parallax),
                    y: (geo.size.height * titlePos.y)
                )
            
            QPMultipleLink_classic(tracks: [track3, track4, track5])
                .disabled(true)
                .scaleEffect(recentAlbumSize)
                .opacity(recentAlbumOpacity)
                .position(
                    x: (geo.size.width * recentAlbumPos.x) + (recentAlbumParallax * parallax),
                    y: (geo.size.height * recentAlbumPos.y)
                )
            
            SearchAlbumLink_classic(album: track6.Album)
                .disabled(true)
                .frame(height: 200)
                .scaleEffect(albumLinkSize)
                .opacity(albumLinkOpacity)
                .position(
                    x: (geo.size.width * albumLinkPos.x) + (albumLinkParallax * parallax),
                    y: (geo.size.height * albumLinkPos.y)
                )
            
            MiniPlayer_classic()
                .disabled(true)
                .scaleEffect(miniplayerSize)
                .opacity(miniplayerOpacity)
                .position(
                    x: (geo.size.width * miniplayerPos.x) + (miniplayerParallax * parallax),
                    y: (geo.size.height * miniplayerPos.y)
                )
            
            Button(action: {
                withAnimation {
                    currentTheme = "classic"
                    FontManager.shared.currentlyChosenTheme = .classic
                }
            }) {
                AlbumWideButton_classic(text: currentTheme == "classic" ? "Selected" : "Select", ArtworkID: "")
                    .frame(width: 200)
            }
                .foregroundStyle(currentTheme == "classic" ? .secondary : .primary)
                .buttonStyle(.plain)
                .position(
                    x: (geo.size.width * selectButtonPos.x) + (selectButtonParallax * parallax),
                    y: (geo.size.height * selectButtonPos.y)
                )
                .onChange(of: geo.frame(in: .global).minX) { oldValue, newValue in
                    parallax = geo.frame(in: .global).minX / geo.frame(in: .global).width
                }
        }
        .background {
            GlobalBackground_classic()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}




#Preview {
    @AppStorage("customFonts") var customFonts: Bool = true
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
//        .task {
//            currentTheme = "classic"
//            globalIPAddress = "server.openmusic.app"
//        }
}
