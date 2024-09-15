//
//  ImageDisplayViews.swift
//  openmusic
//
//  Created by Charlie Giannis on 2022-09-24.
//

import Foundation
import SwiftUI

@MainActor
@Observable final class ArtworkExistsObj {
    var artworkExists: Bool?
    
    init(artworkExists: Bool? = nil) {
        self.artworkExists = artworkExists
    }
    
    func update(ArtworkID: String?) {
        Task.detached { [weak self] in
            let tempartworkExists = ArtworkExists(ArtworkID: ArtworkID)
            DispatchQueue.main.async { [weak self, tempartworkExists] in
                self?.artworkExists = tempartworkExists
            }
        }
    }
}

struct AlbumArtDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var AlbumID: String?
    var ArtworkID: String?
    var Resolution: Resolution
    var Blur: CGFloat
    var BlurOpacity: Double
    var cornerRadius: Double
    @State var albumVideoViewModel: AlbumVideoViewModel = AlbumVideoViewModel()
    var artworkExistsObj: ArtworkExistsObj = ArtworkExistsObj()
    var body: some View {
        ZStack {
            if artworkExistsObj.artworkExists == true {
                if (BlurOpacity > 0) {
                    BetterAsyncImage(url: RetrieveArtwork(ArtworkID: ArtworkID!), animated: false)
                        .cornerRadius(cornerRadius)
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                        //.drawingGroup()
                }
                ZStack {
                    BetterAsyncImage(url: RetrieveArtwork(ArtworkID: ArtworkID!), animated: true)
                    if (AlbumID != nil && albumVideoViewModel.fetchedAlbumVideo != nil) {
                        AnimatedAlbumArtDisplay(albumURL: albumVideoViewModel.fetchedAlbumVideo!)
                    }
                }
                    .cornerRadius(cornerRadius)
            } else {
                if (BlurOpacity > 0) {
                    BetterAsyncImage(url: BuildArtworkURL(imgID: self.ArtworkID, resolution: self.Resolution), animated: false)
                        .cornerRadius(cornerRadius)
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                        //.drawingGroup()
                }
                ZStack {
                    BetterAsyncImage(url: BuildArtworkURL(imgID: self.ArtworkID, resolution: self.Resolution), animated: true)
                    if (AlbumID != nil && albumVideoViewModel.fetchedAlbumVideo != nil) {
                        AnimatedAlbumArtDisplay(albumURL: albumVideoViewModel.fetchedAlbumVideo!)
                    }
                }
                    .cornerRadius(cornerRadius)
            }
        }
        .scaledToFit()
        .onChange(of: ArtworkID) {
            if (AlbumID != nil) {
                albumVideoViewModel.runSearch(albumID: AlbumID!)
            }
        }
        .task {
            self.artworkExistsObj.update(ArtworkID: self.ArtworkID ?? "")
            if (AlbumID != nil) {
                albumVideoViewModel.runSearch(albumID: AlbumID!)
            }
        }
    }
}

struct AlbumArtBGDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var Resolution: Resolution
    var body: some View {
        if (ArtworkExists(ArtworkID: self.ArtworkID ?? "")) {
            BetterAsyncImage(url: RetrieveArtwork(ArtworkID: ArtworkID!), animated: false)
                .aspectRatio(contentMode: .fill)
                .allowsHitTesting(false)
        } else {
            BetterAsyncImage(url: BuildArtworkURL(imgID: self.ArtworkID, resolution: .background), animated: false)
                    .aspectRatio(contentMode: .fill)
                    .allowsHitTesting(false)
        }
    }
}

//#Preview {
//    NowPlayingSheet()
//}

#Preview {
    MiniPlayer(passedNSPath: .constant(NavigationPath()))
}

#Preview {
    Button(action: {}) {
        HStack {
            Spacer()
            VStack {
                Text("hello there")
                Text("hello there")
                Text("hello there")
                Text("hello there")
            }
            Spacer()
        }
        //.border(.green)
        .padding(5)
        .background {
            AlbumBackground(ArtworkID: SearchedAlbum().Artwork, blur: 0, light_opacity: 0, dark_opacity: 0, spin: false)
                
                //.border(.blue)
        }
    }
    .buttonStyle(.plain)
    //.border(.red)
}
