//
//  AnimatedAlbumArtDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-28.
//

import SwiftUI
import AVFoundation
import Combine
import AVKit


struct AnimatedAlbumArtDisplay: View {
    @Environment(\.scenePhase) private var scenePhase
    var albumURL: URL
    @State private var isShowing: Bool = true  // State to track visibility

    var body: some View {
        PlayerView(url: albumURL, isShowing: $isShowing)  // Pass binding
            .aspectRatio(1, contentMode: .fill)
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    isShowing = true
                case .inactive, .background:
                    isShowing = false
                @unknown default:
                    isShowing = false
                }
            }
    }
}

struct PlayerView: UIViewRepresentable {
    var url: URL
    @Binding var isShowing: Bool  // Binding to control playback

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView(frame: .zero, url: url)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        if isShowing {
            uiView.queuePlayer?.play()
        } else {
            uiView.queuePlayer?.pause()
        }
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    var queuePlayer: AVQueuePlayer?
    var playerLooper: AVPlayerLooper?

    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        let playerItem = AVPlayerItem(url: url)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        self.queuePlayer?.playImmediately(atRate: 1.0)
        self.queuePlayer?.isMuted = true
        self.playerLayer.player = self.queuePlayer
        self.layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}



#Preview {
    AnimatedAlbumArtDisplay(albumURL: URL(string: "https://mvod.itunes.apple.com/itunes-assets/HLSMusic122/v4/f7/dc/b9/f7dcb920-1131-a0db-7cb9-5d5ea5e74d9c/P524581196_default.m3u8")!)
}


