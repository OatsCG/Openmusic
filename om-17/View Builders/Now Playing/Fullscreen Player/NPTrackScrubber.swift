//
//  TrackScrubber.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI
import MarqueeText
import CoreMedia
import SwiftData

struct NPTrackScrubber: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @State var isDragging: Bool = false
    @State var localElapsedTime: Double = 0
    @Binding var fullscreen: Bool
    @State var showingAmplitudes: Bool = false
    var body: some View {
        VStack {
            ProgressView(value: 0)
                .progressViewStyle(NPTrackScrubberBar(isDragging: $isDragging, localElapsedTime: $localElapsedTime, showingAmplitudes: $showingAmplitudes))
            if !fullscreen {
                HStack {
                    Text(secondsToText(seconds: self.isDragging ? localElapsedTime : playerManager.elapsedTime))
                    Spacer()
                    Text(secondsToText(seconds: playerManager.durationSeconds))
                }
                    .customFont(fontManager, .caption)
                    .opacity(self.isDragging ? (self.showingAmplitudes ? 0 : 0.7) : 0.45)
            }
        }
    }
}


struct NPTrackScrubberBar: ProgressViewStyle {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Binding var isDragging: Bool
    @Binding var localElapsedTime: Double
    @Binding var showingAmplitudes: Bool
    @State var dragPosition: Double = 0
    @State var dragStartPosition: Double = 0
    @State var dragStartElapsed: Double = 0
    @State var isSnapped: Bool = false
    @State var geo_width: CGFloat = 0
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if (self.isDragging == false) {
                    dragPosition = min(max(value.location.x, 0), geo_width)
                    dragStartPosition = min(max(value.location.x, 0), geo_width)
                    dragStartElapsed = min(max(playerManager.elapsedNormal * geo_width, 0), geo_width)
                    withAnimation(.interactiveSpring(duration: 0.3)) {
                        isDragging = true
                    }
                }
                withAnimation(.interactiveSpring) {
                    dragPosition = min(max(value.location.x, 0), geo_width)
                    var dragNormal: Double = min(max(((dragPosition - (dragStartPosition - dragStartElapsed)) / geo_width), 0), 1)
                    if (abs(playerManager.elapsedNormal - dragNormal) < 0.013) {
                        if (isSnapped == false) {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        isSnapped = true
                        dragPosition = min(max(playerManager.elapsedNormal * geo_width, 0), geo_width)
                        dragNormal = playerManager.elapsedNormal
                    } else {
                        isSnapped = false
                    }
                    let timeToSeek = dragNormal * playerManager.durationSeconds
                    localElapsedTime = timeToSeek
                    
                    if (value.translation.height > 70 && self.playerManager.currentQueueItem?.audio_AVPlayer?.isRemote == false) {
                        self.showingAmplitudes = true
                    } else {
                        self.showingAmplitudes = false
                    }
                }
            }
            .onEnded { _ in
                withAnimation(.interactiveSpring(duration: 0.3)) {
                    self.isDragging = false
                    self.showingAmplitudes = false
                }
                let endNormal: Double = min(max(((dragPosition - (dragStartPosition - dragStartElapsed))) / geo_width, 0), 1)
                
                if (isSnapped == false) {
                    withAnimation(.interactiveSpring) {
                        if (playerManager.currentQueueItem != nil) {
                            playerManager.elapsedTime = endNormal * playerManager.durationSeconds
                            playerManager.elapsedNormal = endNormal
                            playerManager.player.seek(to: endNormal * playerManager.durationSeconds)
                        }
                    }
                    playerManager.play()
                }
            }
    }
    func makeBody(configuration: Configuration) -> some View {
        return Group {
            let currentNormal: CGFloat = min(max(playerManager.elapsedNormal, 0), 1) * geo_width
            let unsnappedWidth: CGFloat = min(max((dragPosition - (dragStartPosition - dragStartElapsed)), 0), geo_width)
            let pressedNormal: CGFloat = isSnapped ? currentNormal : unsnappedWidth
            ScrubberBar_component(isDragging: $isDragging, width: $geo_width, currentNormal: currentNormal, pressedNormal: pressedNormal)
                .gesture(drag)
                .overlay {
                    ScrubberBarAmplitudes(isDragging: $isDragging, showingAmplitudes: $showingAmplitudes)
                    //.border(.red)
                    .offset(y: 20)
                }
        }
    }
}

struct ScrubberBarAmplitudes: View {
    @Environment(PlayerManager.self) var playerManager
    @Binding var isDragging: Bool
    @Binding var showingAmplitudes: Bool
    var body: some View {
        Group {
            if let amplitudes: [Float] = self.playerManager.currentQueueItem?.audio_AVPlayer?.player.amplitudeChart() {
                if (self.showingAmplitudes) {
                    HStack(alignment: .top, spacing: 3) {
                        //Spacer()
                        ForEach(0..<60, id: \.self) { i in
                            let thisAmplitude: Float = amplitudes[i]
                            let ampHeight: CGFloat = CGFloat(thisAmplitude) * 20
                            Capsule().fill(.white.opacity(0.7))
                                .frame(height: ampHeight)
                        }
                        .padding(.vertical, 5)
                        //Spacer()
                    }
                    .onAppear {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                } else if (self.isDragging) {
                    VStack(spacing: 1) {
                        Image(systemName: "waveform")
                            .font(.caption)
                        Image(systemName: "chevron.down")
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .background {
            Rectangle().fill(.black).blur(radius: 10).opacity(0.2)
        }
    }
}


#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return NowPlayingSheet(showingNPSheet: .constant(true), passedNSPath: .constant(NavigationPath()))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
        }
}
