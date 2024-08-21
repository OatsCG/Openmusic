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
        CacheAsyncImage(url: url, transaction: Transaction(animation: .smooth(duration: 0.1))) { phase in
            //AsyncImage(url: url, transaction: Transaction(animation: .spring())){ phase in
            switch phase {
            case .empty:
                if url == nil {
                    DefaultArtwork_component(animated: animated)
                } else {
                    LoadingArtwork_component(animated: animated)
                }
            case .success(let image):
                image
                    .resizable()
                //.transition(.blurReplace)
            case .failure(_):
                DefaultArtwork_component(animated: animated)
            @unknown default:
                DefaultArtwork_component(animated: animated)
            }
        }
        .clipped()
    }
}
