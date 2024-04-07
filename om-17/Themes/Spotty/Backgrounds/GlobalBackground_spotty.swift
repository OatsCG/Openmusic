//
//  GlobalBackground_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_spotty: View {
    var body: some View {
        VStack {
            Rectangle().fill(Color(white: 0.07))
        }
            .ignoresSafeArea()
            //.preferredColorScheme(.dark)
    }
}

#Preview {
    GlobalBackground_spotty()
}
