//
//  AnimatedAlbumArtDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-28.
//

import SwiftUI
import AVFoundation
import Combine
import MediaPlayer
import AVKit

struct AnimatedAlbumArtDisplay: View {
    var albumURL: URL
    let playerLooper: PlayerLooperManager = PlayerLooperManager()
    @State var isShowing: Bool = true
    var body: some View {
        //PlayerView(url: albumURL)
        VideoLooperView(videoURL: albumURL, playerLooperManager: playerLooper)
            .aspectRatio(1, contentMode: .fill)
            .opacity(isShowing ? 1 : 0)
    }
}

class PlayerLooperManager {
    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer? // Add this line

    init() {
        self.playerLooper = nil
        self.queuePlayer = nil // Initialize queuePlayer
    }

    func setupLooper(with playerItem: AVPlayerItem) {
        // Ensure the queuePlayer is initialized with the playerItem
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        // Ensure the looper is created with the queuePlayer and playerItem
        playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
    }
}

struct VideoLooperView: UIViewControllerRepresentable {
    let videoURL: URL
    let playerLooperManager: PlayerLooperManager

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerItem = AVPlayerItem(url: videoURL)
        playerLooperManager.setupLooper(with: playerItem)
        
        

        let playerViewController = AVPlayerViewController()
        if let queuePlayer = playerLooperManager.queuePlayer {
            playerViewController.player = queuePlayer
            playerViewController.updatesNowPlayingInfoCenter = false
            playerViewController.showsPlaybackControls = false
            
            queuePlayer.play() // Start playing automatically
        }
        
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller when SwiftUI updates the view
    }
}

//struct PlayerView: UIViewRepresentable {
//    var url: URL
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        return PlayerUIView(frame: .zero, url: url)
//    }
//}

//class PlayerUIView: UIView {
//    private var avPlayerViewController: AVPlayerViewController?
//
//    init(frame: CGRect, url: URL) {
//        super.init(frame: frame)
//        
//        // Configure the player
//        let playerItem = AVPlayerItem(url: url)
//        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
//        queuePlayer.allowsExternalPlayback = false
//        queuePlayer.audiovisualBackgroundPlaybackPolicy = .pauses
//        queuePlayer.isMuted = true
//        let playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
//        
//        // Setup AVPlayerViewController
//        let avPlayerVC = AVPlayerViewController()
//        avPlayerVC.player = queuePlayer
//        avPlayerVC.updatesNowPlayingInfoCenter = false
//        avPlayerVC.view.frame = self.bounds
//        self.avPlayerViewController = avPlayerVC
//
//        // Add the AVPlayerViewController's view to the UIView
//        self.addSubview(avPlayerVC.view)
//
//        // Start playback
//        queuePlayer.playImmediately(atRate: 1.0)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        avPlayerViewController?.view.frame = bounds
//    }
//}


#Preview {
    AnimatedAlbumArtDisplay(albumURL: URL(string: "https://mvod.itunes.apple.com/itunes-assets/HLSMusic122/v4/f7/dc/b9/f7dcb920-1131-a0db-7cb9-5d5ea5e74d9c/P524581196_default.m3u8")!)
}


