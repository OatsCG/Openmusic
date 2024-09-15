//
//  PlaylistArtDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-11.
//

import SwiftUI
import Combine

struct PlaylistArtwork: View {
    var playlist: Playlist
    var animate: Bool
    var body: some View {
        if (playlist.Image == nil) {
            PlaylistArtCanvas(playlistID: playlist.PlaylistID, animate: animate)
        } else {
            if (PlaylistArtworkExists(playlistID: self.playlist.PlaylistID)) {
                BetterAsyncImage(url: RetrievePlaylistArtwork(playlistID: self.playlist.PlaylistID), animated: animate)
                    .scaledToFit()
            } else {
                BetterAsyncImage(url: URL(string: playlist.Image!), animated: animate)
                    .scaledToFit()
            }
        }
    }
}


struct PlaylistArtCanvas: View {
    var playlistID: UUID
    var animate: Bool
    var random: Random
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    init(playlistID: UUID, animate: Bool) {
        self.playlistID = playlistID
        self.animate = animate
        self.random = Random(playlistID) // ↓ ↓ ↓ ↓ 0.05
        self.timer = Timer.publish(every: animate ? 0.03 : 100000, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        GeometryReader { geo in
            Canvas(
                opaque: true,
                colorMode: .linear,
                rendersAsynchronously: false
            ) { context, size in
                random.reset()
                let rect = CGRect(origin: .zero, size: size)
                context.fill(
                    Rectangle().path(in: rect),
                    with: .style(.background)
                )
                var paths: [Path] = []
                
                for _ in 1...25 {
//                    let xposfixed: Float = Float(random.next() * (size.width * 2) + (xOffset * (random.next() - 0.5)))
//                    let xposmod: Float = Float(size.width * 2)
//                    let xpos = CGFloat(xposfixed.truncatingRemainder(dividingBy: xposmod) - Float(size.width / 2))
                    let velx: Double = random.next() - 0.5
                    let vely: Double = random.next() - 0.5
                    let radius: Double = (size.width / 4) + random.next() * (size.width / 4)
                    
                    let xposfixed: Double = (random.next() * size.width) + Double(xOffset * velx)
                    let xmodded: Double = mod(xposfixed, size.width)
                    let xpos: CGFloat = (xmodded * 2) - (size.width / 2) - radius
                    //let xpos: CGFloat = xmodded - radius
                    
                    
                    let yposfixed: Double = (random.next() * size.width) + Double(xOffset * vely)
                    let ymodded: Double = mod(yposfixed, size.width)
                    let ypos: CGFloat = (ymodded * 2) - (size.width / 2) - radius
                    //let ypos: CGFloat = ymodded - radius
                    
                    
                    let rect = CGRect(origin: CGPoint(
                        x: xpos,
                        y: ypos
                    ), size: CGSize(
                        width: radius * 2,
                        height: radius * 2
                    ))
                    
                    paths.append(Circle().path(in: rect))
                    
                }
                let colour = random.next()
                for path in paths {
                    context.fill(path, with: .color(Color(hue: colour + (random.next()*0.3), saturation: 0.5, brightness: 1, opacity: 0.1)))
                    //context.fill(path, with: .color(Color(hue: random.next(), saturation: 0.5, brightness: 1, opacity: 0.1)))
                }
                
            }
                .saturation(0.2)
                .blur(radius: geo.size.width / 12, opaque: true)
                .saturation(20)
            
                .blur(radius: geo.size.width / 20, opaque: true)
                .saturation(0.4)
                //.drawingGroup()
                .onReceive(timer) { _ in
                    withAnimation {
                        xOffset = xOffset + geo.size.width / 100
                        yOffset = yOffset + geo.size.width / 100
                    }
                }
                
        }
            .aspectRatio(1, contentMode: .fit)
    }
}

struct PlaylistArtDisplay: View {
    var playlist: Playlist
    var Blur: CGFloat
    var BlurOpacity: Double
    var cornerRadius: Double
    var body: some View {
        ZStack {
            PlaylistArtwork(playlist: playlist, animate: false)
                .cornerRadius(cornerRadius)
                .blur(radius: Blur)
                .opacity(BlurOpacity)
                //.drawingGroup()
            PlaylistArtwork(playlist: playlist, animate: true)
                //.background(.black)
                .cornerRadius(cornerRadius)
        }
            .scaledToFit()
    }
}
struct PlaylistArtBGDisplay: View {
    var playlist: Playlist
    var body: some View {
        PlaylistArtwork(playlist: playlist, animate: false)
    }
}

//#Preview {
//    PlaylistArtDisplay(playlistID: UUID(), Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
//}
