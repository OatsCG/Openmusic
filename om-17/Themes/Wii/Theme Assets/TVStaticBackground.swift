//
//  TVStaticBackground.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-14.
//

import SwiftUI

struct TVStaticBackground: View {
    var body: some View {
        ZStack {
            Rectangle().fill(.background)
            TVStaticLines()
            TVStaticFuzz()
        }
            .opacity(0.8)
            .drawingGroup()
    }
}

#Preview {
    TVStaticBackground()
}
