//
//  globalBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_wii: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var yoffset: Double = 0
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            GeometryReader { geo in
                VStack(spacing: 1) {
                    ForEach((1...(Int((geo.size.height <= 20 ? 30 : geo.size.height)) / 10)), id: \.self) {_ in
                        Rectangle().fill(.quinary)
                            .opacity(0.4)
                            .frame(width: geo.size.width, height: 10)
                            .offset(y: yoffset)
                        
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)
                    .repeatForever(autoreverses: false)) {
                        //yoffset = -11
                    }
            })
        }
        .drawingGroup()
    }
}

#Preview {
    GlobalBackground_wii()
}
