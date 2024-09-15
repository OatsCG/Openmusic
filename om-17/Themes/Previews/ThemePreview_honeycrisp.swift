//
//  ThemePreview_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-06.
//

import SwiftUI

struct ThemePreview_honeycrisp: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage("currentTheme") var currentTheme: String = "honeycrisp"
    @State var parallax: CGFloat = 0
    // input tracks
    @Binding var track1: FetchedTrack
    @Binding var track2: FetchedTrack
    @Binding var track3: FetchedTrack
    @Binding var track4: FetchedTrack
    @Binding var track5: FetchedTrack
    @Binding var track6: FetchedTrack
    @Binding var track7: FetchedTrack
    @Binding var dot: CGFloat
    // Positions
    var songLinkPos: CGPoint = CGPointMake(0.65, 0.1)
    var playButtonPos: CGPoint = CGPointMake(0.2, 0.11)
    var backButtonPos: CGPoint = CGPointMake(0.85, 0.2)
    var trackLinkPos: CGPoint = CGPointMake(0.38, 0.21)
    var titlePos: CGPoint = CGPointMake(0.5, 0.33)
    var albumLinkPos: CGPoint = CGPointMake(0.175, 0.55)
    var recentAlbumPos: CGPoint = CGPointMake(0.66, 0.53)
    var miniplayerPos: CGPoint = CGPointMake(0.5, 0.72)
    var selectButtonPos: CGPoint = CGPointMake(0.5, 0.86)
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
    var miniplayerSize: CGFloat = 0.85
    // opacities
    var songLinkOpacity: CGFloat = 0.8
    var playButtonOpacity: CGFloat = 0.65
    var backButtonOpacity: CGFloat = 0.65
    var trackLinkOpacity: CGFloat = 0.8
    var titleOpacity: CGFloat = 1
    var albumLinkOpacity: CGFloat = 0.8
    var recentAlbumOpacity: CGFloat = 0.8
    var miniplayerOpacity: CGFloat = 0.7
    var body: some View {
        GeometryReader { geo in
            GlobalBackground_honeycrisp()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contentShape(Rectangle())
                .overlay {
                    RoundedRectangle(cornerRadius: 20).fill(.clear)
                        .stroke(
                            .pink,
                            style: StrokeStyle(lineWidth: 2)
                        )
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.77)
                .position(
                    x: (geo.size.width * 0.5),
                    y: (geo.size.height * 0.42)
                )
            
            SearchTrackLink_honeycrisp(track: track1)
                .disabled(true)
                .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .compositingGroup()
                .scaleEffect(songLinkSize)
                .opacity(songLinkOpacity)
                .position(
                    x: (geo.size.width * songLinkPos.x) + (songLinkParallax * parallax),
                    y: (geo.size.height * songLinkPos.y)
                )
            NPPlayButton_honeycrisp()
                .disabled(true)
                .scaleEffect(playButtonSize)
                .opacity(playButtonOpacity)
                .position(
                    x: (geo.size.width * playButtonPos.x) + (playButtonParallax * parallax),
                    y: (geo.size.height * playButtonPos.y)
                )
            TrackLink_honeycrisp(track: track2)
                .disabled(true)
                .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
                .compositingGroup()
                .scaleEffect(trackLinkSize)
                .opacity(trackLinkOpacity)
                .position(
                    x: (geo.size.width * trackLinkPos.x) + (trackLinkParallax * parallax),
                    y: (geo.size.height * trackLinkPos.y)
                )
            NPBackButton_honeycrisp()
                .disabled(true)
                .scaleEffect(backButtonSize)
                .opacity(backButtonOpacity)
                .position(
                    x: (geo.size.width * backButtonPos.x) + (backButtonParallax * parallax),
                    y: (geo.size.height * backButtonPos.y)
                )
            
            QPMultipleLink_honeycrisp(tracks: [track3, track4, track5])
                .disabled(true)
                .scaleEffect(recentAlbumSize)
                .opacity(recentAlbumOpacity)
                .position(
                    x: (geo.size.width * recentAlbumPos.x) + (recentAlbumParallax * parallax),
                    y: (geo.size.height * recentAlbumPos.y)
                )
            
            HStackWrapped(rows: 1) {
                SearchAlbumLink_honeycrisp(album: track6.Album)
                    .frame(width: SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: 210)
            }
                .disabled(true)
                .scaleEffect(albumLinkSize)
                .opacity(albumLinkOpacity)
                .position(
                    x: (geo.size.width * albumLinkPos.x) + (albumLinkParallax * parallax),
                    y: (geo.size.height * albumLinkPos.y)
                )
            
            MiniPlayer_honeycrisp()
                .frame(height: Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                .aspectRatio(contentMode: .fit)
                .disabled(true)
                .scaleEffect(miniplayerSize)
                .opacity(miniplayerOpacity)
                .position(
                    x: (geo.size.width * miniplayerPos.x) + (miniplayerParallax * parallax),
                    y: (geo.size.height * miniplayerPos.y)
                )
            
            Text("Honeycrisp")
                .foregroundStyle(.pink)
                .customFont(fontManager, .largeTitle, bold: true)
                .scaleEffect(titleSize)
                .opacity(titleOpacity)
                .position(
                    x: (geo.size.width * titlePos.x) + (titleParallax * parallax),
                    y: (geo.size.height * titlePos.y)
                )
            
            Button(action: {
                withAnimation {
                    currentTheme = "honeycrisp"
                    FontManager.shared.currentlyChosenTheme = .honeycrisp
                }
            }) {
                AlbumWideButton_honeycrisp(text: currentTheme == "honeycrisp" ? "Selected" : "Select", ArtworkID: "")
                    .frame(width: 200)
            }
                .foregroundStyle(currentTheme == "honeycrisp" ? .secondary : .primary)
                .buttonStyle(.plain)
                .position(
                    x: (geo.size.width * selectButtonPos.x) + (selectButtonParallax * parallax),
                    y: (geo.size.height * selectButtonPos.y)
                )
                .onChange(of: geo.frame(in: .scrollView).minX) { oldValue, newValue in
                    Task {
                        let updParallax = ((geo.frame(in: .scrollView).minX - 30) / geo.size.width)
                        let updDot = 0.3 + 0.6 * min(max(1 - abs(parallax), 0), 1)
                        DispatchQueue.main.async {
                            self.parallax = updParallax
                            self.dot = updDot
                        }
                    }
                }
                .onAppear {
                    parallax = ((geo.frame(in: .scrollView).minX - 30) / geo.size.width)
                    dot = 0.3 + 0.6 * min(max(1 - abs(parallax), 0), 1)
                }
        }
    }
}
