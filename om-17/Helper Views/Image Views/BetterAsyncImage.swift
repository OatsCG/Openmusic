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
    @State private var currentImage: Image? = nil // Store the currently displayed image
    var customTransaction: Transaction = Transaction(animation: .smooth(duration: 0.1))

    var body: some View {
        CacheAsyncImage(url: url, transaction: customTransaction) { phase in
            switch phase {
            case .empty:
                if url == nil {
                    DefaultArtwork_component(animated: animated)
                } else if let image = currentImage {
                    image
                        .resizable()
                } else {
                    LoadingArtwork_component(animated: animated)
                }
            case .success(let image):
                image
                    .resizable()
                    .onAppear {
                        currentImage = image // Update the currently displayed image
                    }
            case .failure(_):
                DefaultArtwork_component(animated: animated)
            @unknown default:
                DefaultArtwork_component(animated: animated)
            }
        }
        .clipped()
    }
}

