//
//  DefaultArtwork_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-05.
//

import SwiftUI

struct DefaultArtwork_classic: View {
    @Environment(\.colorScheme) var colorScheme
    var animated: Bool
    var body: some View {
//        Rectangle().fill(.ultraThinMaterial)
//            .scaledToFill()
            //.compositingGroup()
        Image(colorScheme == .dark ? .defaultDarkClassic : .defaultLightClassic)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    DefaultArtwork_classic(animated: true)
        .scaledToFit()
}
//#Preview {
//    NowPlayingSheet()
//        .tint(.white)
//        .environment(PlayerManager())
//}
