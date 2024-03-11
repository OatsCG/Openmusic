//
//  MiniPlayer_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI
import MarqueeText

struct MiniPlayer_classic: View {
    @Environment(PlayerManager.self) var playerManager
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
                            .customFont(.callout)
                        Spacer()
                    }
                } else {
                    MarqueeText(
                        text: playerManager.currentQueueItem!.Track.Title,
                        font: FontManager.currentThemeUIFont(.callout),
                        leftFade: 16,
                        rightFade: 16,
                        startDelay: 3
                    )
                    MarqueeText(
                        text: playerManager.currentQueueItem!.Track.Album.Title + (playerManager.currentQueueItem!.Track.Album.Artists.count > 0 ? (" • " + stringArtists(artistlist: playerManager.currentQueueItem!.Track.Album.Artists)) : (" • Various Artists")),
                        font: FontManager.currentThemeUIFont(.subheadline),
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
                    AlbumBackground(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, blur: 30, light_opacity: 0.2, dark_opacity: 0.2, spin: false)
                }
            })
            .frame(height: Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
            .aspectRatio(contentMode: .fit)
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding([.horizontal, .bottom], 5)
            .background(alignment: .top, content: {
                Rectangle().fill(.thinMaterial)
                    .mask(LinearGradient(gradient: Gradient(colors: [.clear, .clear, .black, .black]), startPoint: .top, endPoint: .bottom))
            })
    }
}

#Preview {
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        MiniPlayer_classic()
            .environment(playerManager)
            .task {
                playerManager.currentQueueItem = QueueItem(from: FetchedTrack(default: true))
            }
        Spacer()
    }
    //.background(.gray)
}
