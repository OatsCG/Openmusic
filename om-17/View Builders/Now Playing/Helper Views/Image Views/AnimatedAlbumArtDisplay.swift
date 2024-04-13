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
    var albumURL: URL
    @State var isShowing: Bool = true
    var body: some View {
        ZStack {
            PlayerView(url: albumURL)
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            isShowing = false
                        }
                    }) {
                        Image(systemName: "video.slash.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .hidden()
                    Spacer()
                }
            }
        }
            .aspectRatio(1, contentMode: .fill)
            .opacity(isShowing ? 1 : 0)
    }
}

struct PlayerView: UIViewRepresentable {
    var url: URL
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, url: url)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    var queuePlayer: AVQueuePlayer?
    var playerLooper: NSObject?
    var statusObservation: NSKeyValueObservation?

    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        //queuePlayer.play()
        self.queuePlayer?.playImmediately(atRate: 1.0)
        self.playerLayer.player = self.queuePlayer
        self.layer.addSublayer(self.playerLayer)
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


