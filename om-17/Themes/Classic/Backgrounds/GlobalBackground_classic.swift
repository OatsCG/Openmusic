//
//  globalBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_classic: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            if (colorScheme == .dark) {
                Color(red: 0.05, green: 0.05, blue: 0.05)
            } else {
                Color(.white)
            }
        }
            .ignoresSafeArea()
    }
}

#Preview {
    GlobalBackground_classic()
}
