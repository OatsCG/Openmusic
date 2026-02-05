//
//  MiniPlayer_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI
import MarqueeText

struct MiniPlayer_spotty: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 4)
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                if let currentQueueItem = playerManager.currentQueueItem {
                    MarqueeText(
                        text: currentQueueItem.Track.Title,
                        font: FontManager.shared.currentThemeUIFont(fontManager, .callout),
                        leftFade: 16,
                        rightFade: 16,
                        startDelay: 3
                    )
                    .geometryGroup()
                    .id(currentQueueItem.Track.Title)
                    .transition(transition())
                    MarqueeText(
                        text: currentQueueItem.Track.Album.Title + (currentQueueItem.Track.Album.Artists.count > 0 ? (" • " + stringArtists(artistlist: currentQueueItem.Track.Album.Artists)) : (" • Various Artists")),
                        font: FontManager.shared.currentThemeUIFont(fontManager, .subheadline),
                        leftFade: 8,
                        rightFade: 10,
                        startDelay: 3
                    )
                    .foregroundStyle(.secondary)
                    .geometryGroup()
                    .id(currentQueueItem.Track.Album.Title)
                    .transition(transition())
                    
                } else {
                    HStack {
                        Text(playerManager.fetchSuggestionsModel.isFetching ? "Loading..." : "Not Playing")
                            .customFont(fontManager, .callout)
                        Spacer()
                    }
                    if playerManager.trackQueue.count > 0 {
                        HStack {
                            Text("\(playerManager.trackQueue.count) Song\(playerManager.trackQueue.count != 1 ? "s" : "") Queued")
                                .customFont(fontManager, .subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
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
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .contentTransition(.symbolEffect(.replace.offUp))
                    .font(.system(size: 20))
            }
                .symbolEffect(.pulse, isActive: !playerManager.is_current_item_ready())
                .foregroundStyle(.primary)
                .padding(.trailing, 10)
        }
            .padding(7)
            .background(alignment: .top, content: {
                ZStack {
                    if (playerManager.currentQueueItem == nil) {
                        Rectangle()
                            .foregroundStyle(Color(white: 0.24))
                    } else {
                        Rectangle()
                            .foregroundStyle(.black)
                        AlbumBackground(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, blur: 400, light_opacity: 0.8, dark_opacity: 0.7, spin: false)
                    }
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding([.horizontal, .bottom], 5)
            .environment(\.colorScheme, .dark)
    }
    
    private func transition() -> AnyTransition {
        return switch playerManager.actionAnimation {
        case .left:
            // text moves left (enters from right, exits to left)
            .asymmetric(
                insertion: .opacity.combined(with: .offset(x: 8)),
                removal: .opacity.combined(with: .offset(x: -8))
            )
        case .right:
            // text moves right (enters from left, exits to right)
            .asymmetric(
                insertion: .opacity.combined(with: .offset(x: -8)),
                removal: .opacity.combined(with: .offset(x: 8))
            )
        case .none:
            .asymmetric(
                insertion: .opacity,
                removal: .opacity
            )
        }
    }
}

#Preview {
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        MiniPlayer_spotty()
            .environment(playerManager)
            .task {
                Task {
                    playerManager.currentQueueItem = QueueItem(from: FetchedTrack(default: true))
                }
            }
        Spacer()
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        ExplorePage(exploreNSPath: .constant(NavigationPath()))
            .environment(playerManager)
            .task {
                //playerManager.currentQueueItem = QueueItem(globalPlayerManager: playerManager, from: FetchedTrack(default: true))
                currentTheme = "spotty"
            }
        Spacer()
    }
}
