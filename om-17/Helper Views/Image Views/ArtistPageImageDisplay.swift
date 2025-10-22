//
//  ArtistPageImageDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

struct ArtistPageImageDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var Resolution: Resolution
    var Blur: CGFloat
    var BlurOpacity: Double
    var cornerRadius: Double
    var aspectRatioValue: CGFloat = 1.5
    var someheight: CGFloat = 400
    var uiImageObj = UIImageObj()
    
    var body: some View {
        ZStack {
            if ArtistBannerExists(ArtworkID: ArtworkID ?? "") {
                if let uiImage = uiImageObj.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: someheight, alignment: .top)
                        .scaledToFill()
                        .cornerRadius(cornerRadius)
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                        .drawingGroup()
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: someheight, alignment: .top)
                        .scaledToFill()
                        .cornerRadius(cornerRadius)
                } else {
                    Rectangle().fill(.clear)
                }
            } else {
                CacheAsyncImage(url: BuildArtistBannerURL(imgID: ArtworkID, resolution: Resolution, aspectRatio: 2), transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.clear)
                    case .success(let image):
                        GeometryReader { geometry in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: someheight, alignment: .top)
                                .clipped()
                                .overlay(
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: geometry.size.width, height: someheight, alignment: .top)
                                        .scaledToFit()
                                        //.aspectRatio(aspectRatioValue, contentMode: .fit)
                                )
                        }
                    case .failure(_):
                        Rectangle().fill(.clear)
                    @unknown default:
                        Rectangle().fill(.clear)
                    }
                }
                .cornerRadius(cornerRadius)
                .blur(radius: Blur)
                .opacity(BlurOpacity)
                .drawingGroup()

                CacheAsyncImage(url: BuildArtistBannerURL(imgID: ArtworkID, resolution: Resolution, aspectRatio: 2), transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.background.secondary)
                    case .success(let image):
                        GeometryReader { geometry in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: someheight, alignment: .top)
                                .clipped()
                                .overlay(
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: geometry.size.width, height: someheight, alignment: .top)
                                        .scaledToFit()
                                )
                        }
                    case .failure(_):
                        Rectangle().fill(.background.secondary)
                    @unknown default:
                        Rectangle().fill(.background.secondary)
                    }
                }
                .cornerRadius(cornerRadius)
            }
        }
        .frame(height: someheight, alignment: .top)
        .allowsHitTesting(false)
        .onAppear {
            if let ArtworkID {
                uiImageObj.loadImage(path: RetrieveArtwork(ArtworkID: ArtworkID).path())
            }
        }
    }
}

@MainActor
@Observable final class UIImageObj {
    var uiImage: UIImage?
    
    init(uiImage: UIImage? = nil) {
        self.uiImage = uiImage
    }
    
    func loadImage(path: String) {
        Task.detached { [weak self] in
            let tempuiImage = UIImage(contentsOfFile: path)
            DispatchQueue.main.async { [weak self, tempuiImage] in
                self?.uiImage = tempuiImage
            }
        }
    }
}

struct ArtistPageBGDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var Resolution: Resolution
    var uiImageObj = UIImageObj()
    
    var body: some View {
        ZStack {
            if ArtistBannerExists(ArtworkID: ArtworkID ?? "") {
                if let uiImage = uiImageObj.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                CacheAsyncImage(url: BuildArtistBannerURL(imgID: ArtworkID, resolution: Resolution, aspectRatio: 1), transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.clear)
                    case .success(let image):
                        image
                            .resizable(capInsets: .init(top: 200, leading: 200, bottom: 200, trailing: 200), resizingMode: .tile)
                            .resizable(resizingMode: .tile)
                    case .failure(_):
                        Rectangle().fill(.clear)
                    @unknown default:
                        Rectangle().fill(.clear)
                    }
                }
            }
        }
        .task {
            if let ArtworkID {
                uiImageObj.loadImage(path: RetrieveArtwork(ArtworkID: ArtworkID).path())
            }
        }
    }
}

#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
