//
//  MiniPlayer_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI
import MarqueeText

struct MiniPlayer_faero: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, Resolution: .cookie, Blur: 20, BlurOpacity: 1, cornerRadius: 11)
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                if (playerManager.currentQueueItem == nil) {
                    HStack {
                        Text("Not Playing")
                            .customFont(fontManager, .callout)
                        Spacer()
                    }
                } else {
                    MarqueeText(
                        text: playerManager.currentQueueItem!.Track.Title,
                        font: FontManager.shared.currentThemeUIFont(fontManager, .callout),
                        leftFade: 16,
                        rightFade: 16,
                        startDelay: 3
                    )
                    MarqueeText(
                        text: playerManager.currentQueueItem!.Track.Album.Title + (playerManager.currentQueueItem!.Track.Album.Artists.count > 0 ? (" • " + stringArtists(artistlist: playerManager.currentQueueItem!.Track.Album.Artists)) : (" • Various Artists")),
                        font: FontManager.shared.currentThemeUIFont(fontManager, .subheadline),
                        leftFade: 8,
                        rightFade: 10,
                        startDelay: 3
                    )
                        .foregroundStyle(.secondary)
                    
                }
            }
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
            }
                .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
                .foregroundStyle(.primary)
                .padding(.trailing, 10)
        }
            .padding(5)
            .background(alignment: .top, content: {
                ZStack {
                    Rectangle().foregroundStyle(.thinMaterial)
                    AeroGlossBG(cornerRadius: 15)
                        .opacity(0.4)
                }
            })
            .overlay {
                AeroGlossOverlay(baseCornerRadius: 15, padding: 0)
            }
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding([.horizontal, .bottom], 5)
    }
}

#Preview {
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        MiniPlayer_faero()
            
            .environment(playerManager)
            .task {
                Task {
                    playerManager.currentQueueItem = await QueueItem(from: FetchedTrack(default: true))
                }
            }
        Spacer()
    }
    //.background(.gray)
}
