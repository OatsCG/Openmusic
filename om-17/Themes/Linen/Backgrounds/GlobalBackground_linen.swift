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
        }
            .ignoresSafeArea()
    }
}

#Preview {
    GlobalBackground_linen()
}
