//
//  BetterAsyncImage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct BetterAsyncImage: View {
    var url: URL?
    var animated: Bool = false
    var body: some View {
        CacheAsyncImage(url: url, transaction: Transaction(animation: .smooth(duration: 0.3))) { phase in
            //AsyncImage(url: url, transaction: Transaction(animation: .spring())){ phase in
            switch phase {
            case .empty:
                GeometryReader { geo in
                    DefaultArtwork_component(animated: animated)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            case .success(let image):
                GeometryReader { geo in
                    image
                        .resizable()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                //.transition(.blurReplace)
            case .failure(_):
                GeometryReader { geo in
                    DefaultArtwork_component(animated: animated)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            @unknown default:
                GeometryReader { geo in
                    DefaultArtwork_component(animated: animated)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
        .clipped()
    }
}
