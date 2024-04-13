//
//  ArtistCookieImageDisplay.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

struct ArtistCookieImageDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(FontManager.self) private var fontManager
    var imgURL: URL?
    var Blur: CGFloat
    var BlurOpacity:Double
    var body: some View {
        ZStack {
            if (imgURL == nil) {
                Image(colorScheme == .light ? "defaultalbumartlight" : "defaultalbumartdark")
                    .resizable()
                    .contentShape(Circle())
                    .clipShape(Circle())
                    .blur(radius: Blur)
                Image(colorScheme == .light ? "defaultalbumartlight" : "defaultalbumartdark")
                    .resizable()
                    .contentShape(Circle())
                    .clipShape(Circle())
            } else {
                //CachedAsyncImage(url: URL(string: imgURL), transaction: Transaction(animation: .spring())){ phase in
                BetterAsyncImage(url: imgURL)
                    .contentShape(Circle())
                    .clipShape(Circle())
                    .blur(radius: Blur)
                    .opacity(BlurOpacity)
                
                //CachedAsyncImage(url: URL(string: imgURL), transaction: Transaction(animation: .spring())){ phase in
                BetterAsyncImage(url: imgURL)
                    .contentShape(Circle())
                    .clipShape(Circle())
            }
        }
        .scaledToFit()
    }
}

#Preview {
    @Environment(FontManager.self) var fontManager
    return ScrollView(.horizontal) {
        HStack {
            Button(action: {}) {
                HStack {
                    ArtistCookieImageDisplay(imgURL: BuildArtistCookieImageURL(imgID: SearchedArtist(default: true).Profile_Photo, resolution: .cookie), Blur: 6, BlurOpacity: 0.6)
                    //.containerRelativeFrame(.horizontal, count: 20, span: 1, spacing: 0)
                    Text(SearchedArtist(default: true).Name)
                        .foregroundColor(.primary)
                        .customFont(fontManager, .headline)
                }
                .frame(height: 70)
            }
                .border(.red)
            ArtistCookie(artist: SearchedArtist(default: true))
            ArtistCookie(artist: SearchedArtist(default: true))
        }
    }
}
