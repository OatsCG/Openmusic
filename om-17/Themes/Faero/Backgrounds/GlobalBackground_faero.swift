//
//  globalBackground_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_faero: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            AeroBG(colorDark: .blue, colorLight: .mint)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            Text("hello!")
        }
    }
    .background {
        GlobalBackground_faero()
    }
}
