//
//  DefaultArtwork_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-05.
//

import SwiftUI

struct DefaultArtwork_faero: View {
    @Environment(\.colorScheme) var colorScheme
    var animated: Bool
    var body: some View {
        Image(colorScheme == .dark ? .defaultDarkClassic : .defaultLightClassic)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    DefaultArtwork_faero(animated: true)
        .scaledToFit()
}
//#Preview {
//    NowPlayingSheet()
//        .tint(.white)
//        .environment(PlayerManager())
//}
