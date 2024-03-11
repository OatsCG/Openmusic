//
//  DefaultArtwork_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-05.
//

import SwiftUI

struct DefaultArtwork_wii: View {
    var animated: Bool
    var body: some View {
        wiidisc(animated: animated)
    }
}

#Preview {
    DefaultArtwork_wii(animated: true)
        .scaledToFit()
}
