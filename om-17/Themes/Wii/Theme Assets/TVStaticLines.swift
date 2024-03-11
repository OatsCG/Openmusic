//
//  TVStaticLines.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-14.
//

import SwiftUI

struct TVStaticLines: View {
    @State var lightlineoffset: Double = 0
    @State var darklineoffset: Double = 0
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack(spacing: 1) {
                    ForEach((1...(Int(geo.size.height) / 10) + 1), id: \.self) {index in
                        Rectangle().fill(.quaternary)
                            .opacity(0.6)
                            .frame(width: geo.size.width, height: 10)
                    }
                }
                .offset(x: 0, y: lightlineoffset)
                .animation(Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false), value: lightlineoffset)
            }
            GeometryReader { geo in
                VStack(spacing: 30) {
                    ForEach((1...(Int(geo.size.height) / 4)), id: \.self) {index in
                        Rectangle().fill(.quaternary)
                            .opacity(0.25)
                            .frame(width: geo.size.width, height: 50)
                    }
                }
                .offset(x: 0, y: darklineoffset)
                .animation(Animation.linear(duration: 10)
                    .repeatForever(autoreverses: false), value: lightlineoffset)
            }
        }
        .task {
            if (UserDefaults.standard.bool(forKey: "themeAnimations") == true) {
                lightlineoffset = -11
                darklineoffset = -80
            }
        }
    }
}

#Preview {
    TVStaticLines()
}

#Preview {
    Text("Hello!")
        .padding()
        .contentShape(Rectangle())
        .background {
            //Color.red
            TVStaticLines()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
}
