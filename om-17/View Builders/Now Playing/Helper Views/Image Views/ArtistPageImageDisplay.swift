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
    var body: some View {
        ZStack {
            if (ArtistBannerExists(ArtworkID: self.ArtworkID ?? "")) {
                if let uiImage = UIImage(contentsOfFile: RetrieveArtwork(ArtworkID: ArtworkID!).path()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: someheight, alignment: .top)
                        
                        .scaledToFill()
                        //.aspectRatio(aspectRatioValue, contentMode: .fill)
                        .cornerRadius(cornerRadius)
                        .blur(radius: Blur)
                        .opacity(BlurOpacity)
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: someheight, alignment: .top)
                        .scaledToFill()
                        //.aspectRatio(contentMode: .fill)
                        .cornerRadius(cornerRadius)
                }
            } else {
                CacheAsyncImage(url: BuildArtistBannerURL(imgID: self.ArtworkID, resolution: self.Resolution, aspectRatio: 2), transaction: Transaction(animation: .spring())){ phase in
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
                
                //AsyncImage(url: BuildArtistBannerURL(imgID: self.ArtworkID, size: self.Resolution, aspectRatio: 2), transaction: Transaction(animation: .spring())){ phase in
                CacheAsyncImage(url: BuildArtistBannerURL(imgID: self.ArtworkID, resolution: self.Resolution, aspectRatio: 2), transaction: Transaction(animation: .spring())){ phase in
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
                                        //.aspectRatio(aspectRatioValue, contentMode: .fit)
                                )
                        }
                            //.border(.blue, width: 5)
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
        //.aspectRatio(aspectRatioValue, contentMode: .fill)
        .allowsHitTesting(false)
        //.scaledToFit()
    }
}

struct ArtistPageBGDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var Resolution: Resolution
    var body: some View {
        ZStack {
            if (ArtistBannerExists(ArtworkID: self.ArtworkID ?? "")) {
                if let uiImage = UIImage(contentsOfFile: RetrieveArtwork(ArtworkID: ArtworkID!).path()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                //AsyncImage(url: BuildArtistBannerURL(imgID: self.ArtworkID, size: self.Resolution, aspectRatio: 1), transaction: Transaction(animation: .spring())){ phase in
                CacheAsyncImage(url: BuildArtistBannerURL(imgID: self.ArtworkID, resolution: self.Resolution, aspectRatio: 1), transaction: Transaction(animation: .spring())){ phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.clear)
                    case .success(let image):
                        image
                            .resizable(capInsets: .init(top: 200, leading: 200, bottom: 200, trailing: 200), resizingMode: .tile)
                            //.aspectRatio(contentMode: .fill)
                            .resizable(resizingMode: .tile)
                        
                    case .failure(_):
                        Rectangle().fill(.clear)
                    @unknown default:
                        Rectangle().fill(.clear)
                    }
                }
            }
        }
    }
}


#Preview {
    SearchArtistContent(artist: SearchedArtist())
}
