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
    var customTransaction: Transaction = Transaction(animation: .smooth(duration: 0.31))
    @State private var ArtworkURL: URL?
    
    var body: some View {
        ZStack {
            if artworkExistsObj.artworkExists == true {
                if (BlurOpacity > 0) {
                    BetterAsyncImage(url: ArtworkURL, animated: false, customTransaction: customTransaction)
                        .cornerRadius(cornerRadius)
                        .drawingGroup()
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                }
                ZStack {
                    BetterAsyncImage(url: ArtworkURL, animated: true, customTransaction: customTransaction)
                    if (AlbumID != nil && albumVideoViewModel.fetchedAlbumVideo != nil && AlbumID == albumVideoViewModel.vAlbumID) {
                        AnimatedAlbumArtDisplay(albumURL: albumVideoViewModel.fetchedAlbumVideo!)
                    }
                }
                    .cornerRadius(cornerRadius)
            } else {
                if BlurOpacity > 0 {
                    BetterAsyncImage(url: BuildArtworkURL(imgID: ArtworkID, resolution: Resolution), animated: false, customTransaction: customTransaction)
                        .cornerRadius(cornerRadius)
                        .drawingGroup()
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                }
                ZStack {
                    BetterAsyncImage(url: BuildArtworkURL(imgID: ArtworkID, resolution: Resolution), animated: true, customTransaction: customTransaction)
                    if AlbumID == albumVideoViewModel.vAlbumID, let fetchedAlbumVideo = albumVideoViewModel.fetchedAlbumVideo {
                        AnimatedAlbumArtDisplay(albumURL: fetchedAlbumVideo)
                    }
                }
                    .cornerRadius(cornerRadius)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if let ArtworkID {
                ArtworkURL = RetrieveArtwork(ArtworkID: ArtworkID)
            }
        }
        .onChange(of: ArtworkID) {
            if let AlbumID {
                albumVideoViewModel.runSearch(albumID: AlbumID)
            }
            if let ArtworkID {
                ArtworkURL = RetrieveArtwork(ArtworkID: ArtworkID)
            }
        }
        .task {
            artworkExistsObj.update(ArtworkID: ArtworkID ?? "")
            if let AlbumID {
                albumVideoViewModel.runSearch(albumID: AlbumID)
            }
        }
    }
}

struct AlbumArtBGDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var Resolution: Resolution
    
    var body: some View {
        if let ArtworkID, ArtworkExists(ArtworkID: ArtworkID) {
            BetterAsyncImage(url: RetrieveArtwork(ArtworkID: ArtworkID), animated: false, customTransaction: Transaction(animation: .easeInOut(duration: 0.6)))
                .aspectRatio(contentMode: .fill)
                .allowsHitTesting(false)
        } else {
            BetterAsyncImage(url: BuildArtworkURL(imgID: ArtworkID, resolution: .background), animated: false, customTransaction: Transaction(animation: .easeInOut(duration: 0.6)))
                    .aspectRatio(contentMode: .fill)
                    .allowsHitTesting(false)
        }
    }
}

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
        .padding(5)
        .background {
            AlbumBackground(ArtworkID: SearchedAlbum().Artwork, blur: 0, light_opacity: 0, dark_opacity: 0, spin: false)
        }
    }
    .buttonStyle(.plain)
}
