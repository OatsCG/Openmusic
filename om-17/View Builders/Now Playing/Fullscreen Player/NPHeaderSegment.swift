//
//  NPHeaderArt.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-12.
//

import SwiftUI
import MarqueeText
import YouTubePlayerKit

struct NPHeaderSegment: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Binding var fullscreen: Bool
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    @State var visualWidth: CGFloat = 100
    var body: some View {
        VStack {
            if ((playerManager.currentQueueItem?.isVideo ?? false) && playerManager.currentQueueItem?.video_AVPlayer?.player != nil) {
                YouTubePlayerView(playerManager.currentQueueItem!.video_AVPlayer!.player!)
            } else {
                NPArtwork(fullscreen: $fullscreen, visualWidth: $visualWidth)
                    .overlay {
                        PlayerDebugger()
                    }
            }
            if (playerManager.currentQueueItem != nil && !fullscreen) {
                HStack(alignment: .top) {
                    Menu {
                        Menu {
                            ForEach(playerManager.currentQueueItem!.Track.Album.Artists, id: \.ArtistID) { artist in
                                Button(action: {
                                    passedNSPath.append(SearchArtistContentNPM(artist: artist))
                                    showingNPSheet = false
                                }) {
                                    Label(artist.Name, systemImage: "person.circle.fill")
                                }
                            }
                        } label: {
                            Label("Artists", systemImage: "person.fill")
                        }
                        Button(action: {
                            passedNSPath.append(SearchAlbumContentNPM(album: playerManager.currentQueueItem!.Track.Album))
                            showingNPSheet = false
                        }) {
                            Label("Album", systemImage: "play.square.fill")
                            Text(playerManager.currentQueueItem!.Track.Album.Title)
                        }
                    } label: {
                        VStack(spacing: 0) {
                            MarqueeText(
                                text: playerManager.currentQueueItem!.Track.Album.Title,
                                font: FontManager.shared.currentThemeUIFont(fontManager, .callout),
                                leftFade: 10,
                                rightFade: 10,
                                startDelay: 3,
                                alignment: .leading
                            )
                            .foregroundStyle(.secondary)
                            MarqueeText(
                                text: stringArtists(artistlist: playerManager.currentQueueItem!.Track.Album.Artists),
                                font: FontManager.shared.currentThemeUIFont(fontManager, .caption),
                                leftFade: 10,
                                rightFade: 10,
                                startDelay: 3,
                                alignment: .leading
                            )
                            .foregroundStyle(.tertiary)
                        }
                    }
                    Spacer()
                    Menu {
                        Button(action: {
                            Task {
                                await playerManager.currentQueueItem?.prime_object_fresh(playerManager: playerManager, continueCurrent: false, seek: false)
                            }
                        }) {
                            Label("Refresh Track", systemImage: "arrow.clockwise")
                        }
                        if (playerManager.currentQueueItem?.fetchedPlayback?.YT_Video_ID != nil) {
                            Button(action: {
                                if ((playerManager.currentQueueItem?.isVideo ?? false) == true) {
                                    self.playerManager.currentQueueItem?.setVideo(to: false)
                                } else {
                                    self.playerManager.currentQueueItem?.setVideo(to: true)
                                }
                            }) {
                                Label((playerManager.currentQueueItem?.isVideo ?? false) ? "Hide Video" : "Show Video", systemImage: (playerManager.currentQueueItem?.isVideo ?? false) ? "tv.slash" : "tv")
                            }
                        }
                        if (playerManager.currentQueueItem!.Track.Playback_Clean != nil && playerManager.currentQueueItem!.Track.Playback_Explicit != nil) {
                            Button(action: {
                                playerManager.currentQueueItem!.explicit.toggle()
                                playerManager.pause()
                                Task {
                                    await playerManager.currentQueueItem!.prime_object_fresh(playerManager: playerManager, seek: true)
                                    //playerManager.play()
                                }
                            }) {
                                Label("Toggle Explicity", systemImage: "exclamationmark.square")
                            }
                        }
                    } label: {
                        HStack {
                            if (playerManager.currentQueueItem?.fetchedPlayback?.YT_Video_ID != nil) {
                                Image(systemName: "tv")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.secondary)
                            }
                            PlaybackExplicityDownloadedIcon(track: FetchedTrack(from: playerManager.currentQueueItem!), explicit: playerManager.currentQueueItem!.explicit, isDownloaded: playerManager.currentQueueItem?.audio_AVPlayer?.isRemote == false)
                                .opacity(0.8)
                        }
                    }
                }
                .frame(width: visualWidth)
            }
        }
            .scaleEffect((playerManager.isPlaying || playerManager.currentQueueItem?.isVideo == true) ? 1 : 0.75)
            .disabled(playerManager.shouldSuggestPlaylistCreation == true && playerManager.hasSuggestedPlaylistCreation == false)
            .overlay {
                if (playerManager.shouldSuggestPlaylistCreation == true && playerManager.hasSuggestedPlaylistCreation == false) {
                    ZStack {
                        NPEnjoyingSession()
                            .padding(30)
                    }
                }
            }
            //.contentTransition(.numericText())
    }
}

//#Preview {
//    NPHeaderArt()
//}
