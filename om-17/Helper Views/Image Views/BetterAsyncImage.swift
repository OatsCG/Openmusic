//
//  BetterAsyncImage.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI
import NukeUI

struct BetterAsyncImage: View {
    var url: URL?
    var animated: Bool = false
    @State private var currentImage: Image? = nil
    var customTransaction = Transaction(animation: .smooth(duration: 0.1))

    var body: some View {
        LazyImage(url: url, transaction: customTransaction) { state in
            if let image = state.image {
                image
                    .resizable()
                    .onAppear {
                        currentImage = image
                    }
            } else {
                DefaultArtwork_component(animated: animated)
            }
        }
        .clipped()
    }
}
