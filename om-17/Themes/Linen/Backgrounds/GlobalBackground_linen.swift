//
//  globalBackground_linen.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_linen: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        ZStack {
            Image(.linenbg)
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    GlobalBackground_linen()
}
