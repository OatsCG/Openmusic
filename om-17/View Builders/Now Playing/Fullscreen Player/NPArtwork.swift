//
//  NPArtwork.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-08.
//

import SwiftUI
import SwiftData

struct NPArtwork: View {
    @Environment(PlayerManager.self) var playerManager
    @State var swipeDistance: CGFloat = 0
    @State var artworkOffset: CGFloat = 0
    @State var artworkOpacity: Double = 1
    @State var direction: Int = 0
    @State var shouldSkip: Bool = false
    @State var shouldPrevious: Bool = false
    @Binding var fullscreen: Bool
    @Binding var visualWidth: CGFloat
    var minDistance: CGFloat = 30
    var maxDistance: CGFloat = 200
    var maxThrowDistance: CGFloat = 400
    var body: some View {
        ZStack {
            GeometryReader { geo in
                AlbumArtDisplay(AlbumID: playerManager.currentQueueItem?.Track.Album.AlbumID, ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, Resolution: .hd, Blur: 0, BlurOpacity: 0, cornerRadius: 8)
                    .onChange(of: geo.size.width) { oldValue, newValue in
                        withAnimation {
                            visualWidth = newValue
                        }
                    }
                    .onAppear {
                        withAnimation {
                            visualWidth = geo.size.width
                        }
                    }
            }
                .scaledToFit()
                .shadow(radius: 20)
                .opacity(artworkOpacity)
                .offset(x: (60 * artworkOffset) / (abs(artworkOffset) + 80))
            Image(systemName: direction == -1 ? "forward" : "backward")
                .opacity(min(abs((swipeDistance) / maxDistance), 0.9))
                .symbolVariant((shouldSkip || shouldPrevious) ? .fill : .none)
                .font(.system(size: 60, weight: .light))
                .foregroundStyle(.white)
        }
            .overlay {
                VStack {
                    Spacer()
                    MiniToasts()
                        .padding(.bottom, 20)
                }
            }
            .onTapGesture {
                if (true) {
                    if playerManager.isPlaying {
                        playerManager.pause()
                    } else {
                        playerManager.play()
                    }
                }
            }
            .gesture(DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
                .onChanged({ value in
                    withAnimation(.interactiveSpring) {
                        swipeDistance = value.translation.width
                        artworkOffset = value.translation.width
                        if (swipeDistance > 0) {
                            direction = 1
                        } else if (swipeDistance < 0) {
                            direction = -1
                        }
                        
                        if value.translation.width < -(maxDistance) {
                            if shouldSkip == false {
                                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            }
                            shouldSkip = true
                        } else {
                            shouldSkip = false
                        }
                        if value.translation.width > (maxDistance) {
                            if shouldPrevious == false {
                                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            }
                            shouldPrevious = true
                        } else {
                            shouldPrevious = false
                        }
                    }
                })
                .onEnded({ value in
                    if value.translation.width < -maxDistance || value.predictedEndTranslation.width < -maxThrowDistance {
                        if shouldSkip == false {
                            if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }
                        shouldSkip = true
                    } else if value.translation.width > maxDistance || value.predictedEndTranslation.width > maxThrowDistance {
                        if shouldPrevious == false {
                            if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }
                        shouldPrevious = true
                    }
                    
                    if shouldSkip {
                        print("forward gesture")
                        playerManager.player_forward(userInitiated: true)
                    }
                    if shouldPrevious {
                        print("backward gesture")
                        playerManager.player_backward(userInitiated: true)
                        
                    }
                    if shouldSkip || shouldPrevious {
                        withAnimation(.smooth(duration: 0.3)) {
                            swipeDistance = value.predictedEndTranslation.width
                            artworkOffset = value.predictedEndTranslation.width
                            shouldSkip = false
                            shouldPrevious = false
                        }
                        withAnimation(.interactiveSpring(duration: 0.3, extraBounce: 0.15)) {
                            swipeDistance = 0
                            artworkOpacity = 0
                        } completion: {
                            artworkOffset = -artworkOffset / 10
                            
                            withAnimation(.interactiveSpring(duration: 0.3, extraBounce: 0.15)) {
                                artworkOffset = 0
                                artworkOpacity = 1
                            }
                        }
                    } else {
                        withAnimation(.smooth(duration: 0.3, extraBounce: 0.15)) {
                            swipeDistance = 0
                            artworkOffset = 0
                            artworkOpacity = 1
                        }
                    }
                    
                    
                })
            )
    }
}

#Preview {
    let playerManager = PlayerManager()
    return VStack {
        Spacer()
        MiniPlayer_classic()
            .environment(playerManager)
            .task {
                Task {
                    playerManager.currentQueueItem = QueueItem(from: FetchedTrack(default: true))
                }
            }
        Spacer()
    }
    //.background(.gray)
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)
    
    let playerManager = PlayerManager()
    return NowPlayingSheet(showingNPSheet: .constant(true), passedNSPath: .constant(NavigationPath()))
        .environment(playerManager)
        .environment(DownloadManager())
        .modelContainer(container)
        .task {
            playerManager.queue_songs(tracks: [FetchedTrack(default: true), FetchedTrack(default: true), FetchedTrack(default: true), FetchedTrack(default: true)])
            playerManager.player_forward()
        }
}
