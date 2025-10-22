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
                    Text(secondsToText(seconds: isDragging ? localElapsedTime : playerManager.elapsedTime))
                    Spacer()
                    Text(secondsToText(seconds: playerManager.durationSeconds))
                }
                    .customFont(fontManager, .caption)
                    .opacity(isDragging ? (showingAmplitudes ? 0 : 0.7) : 0.45)
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
    @State var currentNormal: CGFloat = 0
    @State var pressedNormal: CGFloat = 0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if !isDragging {
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
                    if abs(playerManager.elapsedNormal - dragNormal) < 0.013 {
                        if !isSnapped {
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
                    
                    showingAmplitudes = value.translation.height > 70 && playerManager.currentQueueItem?.isDownloaded == true
                }
            }
            .onEnded { _ in
                withAnimation(.interactiveSpring(duration: 0.3)) {
                    isDragging = false
                    showingAmplitudes = false
                }
                let endNormal: Double = min(max(((dragPosition - (dragStartPosition - dragStartElapsed))) / geo_width, 0), 1)
                
                if !isSnapped {
                    withAnimation(.interactiveSpring) {
                        if playerManager.currentQueueItem != nil {
                            playerManager.elapsedTime = endNormal * playerManager.durationSeconds
                            playerManager.elapsedNormal = endNormal
                            playerManager.currentQueueItem?.audio_AVPlayer?.seek(to: endNormal * playerManager.durationSeconds)
                        }
                    }
                    playerManager.play()
                }
            }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return Group {
            ScrubberBar_component(isDragging: $isDragging, width: $geo_width, currentNormal: currentNormal, pressedNormal: pressedNormal)
                .gesture(drag)
                .overlay {
                    ScrubberBarAmplitudes(isDragging: $isDragging, showingAmplitudes: $showingAmplitudes)
                    .offset(y: 20)
                }
                .onChange(of: playerManager.elapsedNormal) {
                    updateNormals()
                }
                .onChange(of: geo_width) {
                    updateNormals()
                }
                .onChange(of: dragPosition) {
                    updateNormals()
                }
                .onChange(of: dragStartPosition) {
                    updateNormals()
                }
                .onChange(of: dragStartElapsed) {
                    updateNormals()
                }
                .onChange(of: isSnapped) {
                    updateNormals()
                }
        }
    }
    
    func updateNormals() {
        Task.detached {
            let currentNormal: CGFloat = await min(max(playerManager.elapsedNormal, 0), 1) * geo_width
            let unsnappedWidth: CGFloat = await min(max((dragPosition - (dragStartPosition - dragStartElapsed)), 0), geo_width)
            let pressedNormal: CGFloat = await isSnapped ? currentNormal : unsnappedWidth
            DispatchQueue.main.async {
                self.currentNormal = currentNormal
                self.pressedNormal = pressedNormal
            }
        }
    }
}

struct ScrubberBarAmplitudes: View {
    @Environment(PlayerManager.self) var playerManager
    @Binding var isDragging: Bool
    @Binding var showingAmplitudes: Bool
    @State var amplitudeChart: [Float]?
    
    var body: some View {
        Group {
            if let amplitudes: [Float] = amplitudeChart {
                if showingAmplitudes {
                    HStack(alignment: .top, spacing: 3) {
                        ForEach(0..<60, id: \.self) { i in
                            let thisAmplitude: Float = amplitudes[i]
                            let ampHeight: CGFloat = CGFloat(thisAmplitude) * 20
                            Capsule().fill(.white.opacity(0.7))
                                .frame(height: ampHeight)
                        }
                        .padding(.vertical, 5)
                    }
                    .onAppear {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                } else if isDragging {
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
                .drawingGroup()
        }
        .task {
            Task {
                amplitudeChart = playerManager.currentQueueItem?.audio_AVPlayer?.player.amplitudeChart()
            }
        }
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
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
