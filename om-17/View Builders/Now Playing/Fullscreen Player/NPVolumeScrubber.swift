//
//  VolumeScrubber.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-20.
//

import SwiftUI
import MarqueeText
import CoreMedia
import AVFAudio
import MediaPlayer

struct NPVolumeScrubber: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @State var isDragging: Bool = false
    @State var inAppVolume: Bool = false
    @State var sysVolume: Float = VolumeObserver.shared.getVolume()
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .opacity(self.isDragging ? 0.7 : 0.45)
            if (inAppVolume) {
                ProgressView(value: 0)
                    .progressViewStyle(NPVolumeScrubberBar(currentVolume: playerManager.appVolume, currentVolumePost: playerManager.appVolume, isDragging: $isDragging))
            } else {
                ProgressView(value: 0)
                    .progressViewStyle(NPSystemVolumeScrubberBar(currentVolume: $sysVolume, currentVolumePost: playerManager.appVolume, isDragging: $isDragging))
                    .overlay {
                        VolumeSlider()
                            .opacity(0)
                    }
            }
            Image(systemName: "speaker.wave.3.fill")
                .opacity(self.isDragging ? 0.7 : 0.45)
            Button(action: {
                withAnimation {
                    inAppVolume.toggle()
                }
            }) {
                Image(systemName: inAppVolume ? "music.note" : "iphone")
                    .customFont(fontManager, .title3)
                    //.dynamicTypeSize(.xxxLarge)
                    .padding(5)
                    .background(inAppVolume ? .white.opacity(0.15) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
        }
            .customFont(fontManager, .caption)
            .onChange(of: AVAudioSession.sharedInstance().outputVolume) {
                print(AVAudioSession.sharedInstance().outputVolume)
            }
    }
}

struct VolumeSlider: UIViewRepresentable {
   func makeUIView(context: Context) -> MPVolumeView {
       VolumeObserver.shared.volumeView
   }

   func updateUIView(_ view: MPVolumeView, context: Context) {}
}


struct NPVolumeScrubberBar: ProgressViewStyle {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PlayerManager.self) var playerManager
    //@State var isDragging = false
    @State var currentVolume: Float
    @State var currentVolumePost: Float
    @Binding var isDragging: Bool
    @State var dragAmount: Float = 0
    @State var geo_width: CGFloat = 0
    var drag: some Gesture {
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if (self.isDragging == false) {
                        withAnimation(.interactiveSpring(duration: 0.3)) {
                            self.isDragging = true
                        }
                    }
                    
                    withAnimation(.interactiveSpring) {
                        dragAmount = Float(value.translation.width / geo_width)
                        currentVolumePost = min(max(currentVolume + dragAmount, 0), 1)
                        playerManager.change_volume(to: currentVolumePost)
                    }
                }
                .onEnded { _ in
                    withAnimation(.interactiveSpring) {
                        currentVolume = currentVolumePost
                        dragAmount = 0
                    }
                    withAnimation(.interactiveSpring(duration: 0.3)) {
                        self.isDragging = false
                    }
                }
        }
    func makeBody(configuration: Configuration) -> some View {
        return Group {
            let currentNormal = min(max(CGFloat(currentVolumePost), 0), 1) * geo_width
            ScrubberBar_component(isDragging: $isDragging, width: $geo_width, currentNormal: currentNormal, pressedNormal: currentNormal)
                .gesture(drag)
        }
    }
}

struct NPSystemVolumeScrubberBar: ProgressViewStyle {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PlayerManager.self) var playerManager
    @Binding var currentVolume: Float
    @State var currentVolumePost: Float
    @Binding var isDragging: Bool
    @State var dragAmount: Float = 0
    @State var geo_width: CGFloat = 0
    var drag: some Gesture {
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if (self.isDragging == false) {
                        withAnimation(.interactiveSpring(duration: 0.3)) {
                            self.isDragging = true
                        }
                        currentVolume = VolumeObserver.shared.getVolume()
                    }
                    
                    withAnimation(.interactiveSpring) {
                        dragAmount = Float(value.translation.width / geo_width)
                        currentVolumePost = min(max(currentVolume + dragAmount, 0), 1)
                        VolumeObserver.shared.setVolume(currentVolumePost)
                    }
                }
                .onEnded { _ in
                    withAnimation(.interactiveSpring(duration: 0.3)) {
                        self.isDragging = false
                    }
                    withAnimation(.interactiveSpring) {
                        dragAmount = 0
                        currentVolume = VolumeObserver.shared.getVolume()
                    }
                }
        }
    func makeBody(configuration: Configuration) -> some View {
        return Group {
            let currentNormal = min(max(CGFloat(currentVolumePost), 0), 1) * geo_width
            ScrubberBar_component(isDragging: $isDragging, width: $geo_width, currentNormal: currentNormal, pressedNormal: currentNormal)
                .gesture(drag)
                .onChange(of: VolumeObserver.shared.getVolume()) {
                    if (isDragging == false) {
                        withAnimation(.interactiveSpring) {
                            currentVolume = VolumeObserver.shared.getVolume()
                            currentVolumePost = currentVolume
                        }
                    }
                }
                .onAppear {
                    currentVolume = VolumeObserver.shared.getVolume()
                    currentVolumePost = currentVolume
                }
        }
    }
}
