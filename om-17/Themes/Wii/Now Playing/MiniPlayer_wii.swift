//
//  MiniPlayer_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI
import MarqueeText

struct MiniPlayer_wii: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 4).fill(.clear)
                        .stroke(.wiiborder, lineWidth: 1)
                }
                .padding(.vertical, 6)
                .padding(.leading, 3)
                .padding(.trailing, 8)
                .background {
                    UnevenRoundedRectangle(bottomTrailingRadius: 15, topTrailingRadius: 15).fill(.quinary).stroke(.tertiary)
                        .padding(.leading, -100)
                }
                .padding([.top], 1)
                //.opacity(0.1)
            Spacer()
            VStack(alignment: .leading) {
                if (playerManager.currentQueueItem == nil) {
                    Text("Not Playing")
                        .customFont(fontManager, .callout, bold: true)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                } else {
                    Text(playerManager.currentQueueItem!.Track.Title)
                        .customFont(fontManager, .callout, bold: true)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 15)
            Spacer()
            Button(action: {
                if playerManager.isPlaying {
                    playerManager.pause()
                } else {
                    playerManager.play()
                }
            }) {
                Image(systemName: (playerManager.isPlaying) ? "pause.fill" : "play.fill")
                    .contentTransition(.symbolEffect(.replace.offUp))
                    .font(.system(size: 20))
                    .padding(.all, 10)
                    .padding(.leading, 5)
                    .background {
                        UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 50).fill(.quinary).stroke(.tertiary)
                            .padding(.trailing, -100)
                            
                    }
                    //.padding(.vertical, 10)
                    //.padding([.top], 1)
            }
                .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
                .foregroundStyle(.secondary)
        }
            .padding(5)
            .background(alignment: .top, content: {
                wiiMPBackground()
                    .padding([.horizontal, .bottom], -1)
                    .padding(.top, 1)
            })
            .contentShape(.rect)
            .clipped()
            .clipShape(.rect)
            //.padding([.horizontal, .bottom], 5)
    }
}

import CoreGraphics


struct wiiMPBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        GeometryReader { geo in
            Path { path in
                path.move(
                    to: CGPoint(
                        x: 0,
                        y: 0
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: 25,
                        y: 0
                    )
                )
                //CURVE 1.1
                path.addCurve(
                    to: CGPoint(
                        x: 60,
                        y: 7.5
                    ),
                    control1: CGPoint(
                        x: 45,
                        y: 0
                    ),
                    control2: CGPoint(
                        x: 60,
                        y: 7.5
                    )
                )
                //CURVE 1.2
                path.addCurve(
                    to: CGPoint(
                        x: 100,
                        y: 15
                    ),
                    control1: CGPoint(
                        x: 60,
                        y: 7.5
                    ),
                    control2: CGPoint(
                        x: 75,
                        y: 15
                    )
                )
                
                
                path.addLine(
                    to: CGPoint(
                        x: geo.size.width - 100,
                        y: 15
                    )
                )
                //CURVE 2.1
                path.addCurve(
                    to: CGPoint(
                        x: geo.size.width - 60,
                        y: 7.5
                    ),
                    control1: CGPoint(
                        x: geo.size.width - 75,
                        y: 15
                    ),
                    control2: CGPoint(
                        x: geo.size.width - 60,
                        y: 7.5
                    )
                )
                //CURVE 2.2
                path.addCurve(
                    to: CGPoint(
                        x: geo.size.width - 20,
                        y: 0
                    ),
                    control1: CGPoint(
                        x: geo.size.width - 60,
                        y: 7.5
                    ),
                    control2: CGPoint(
                        x: geo.size.width - 45,
                        y: 0
                    )
                )
                //LOOP BACK
                path.addLine(
                    to: CGPoint(
                        x: geo.size.width,
                        y: 0
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: geo.size.width,
                        y: geo.size.height
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: 0,
                        y: geo.size.height
                    )
                )
            }
            .stroke(.wiiborder, lineWidth: 2)
            .fill(Color(white: colorScheme == .dark ? 0.15 : 0.97))
        }
    }
}



#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        MiniPlayer_wii()
            .environment(playerManager)
            .task {
                currentTheme = "wii"
                Task {
                    playerManager.currentQueueItem = await QueueItem(from: FetchedTrack(default: true))
                }
            }
        Spacer()
    }
    //.background(.gray)
}
