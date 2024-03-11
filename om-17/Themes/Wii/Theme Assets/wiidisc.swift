//
//  wiidisc.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-09.
//

import SwiftUI

struct wiidiscalone: View {
    var spin: Bool = false
    let gradient = Gradient(
            stops: [
                .init(color: Color(.systemBackground), location: 0),
                .init(color: .clear, location: 0.1),
                .init(color: Color(.systemBackground), location: 0.18),
                .init(color: .clear, location: 0.28),
                .init(color: Color(.systemBackground).opacity(0.3), location: 0.38),
                .init(color: .clear, location: 0.46),
                .init(color: Color(.systemBackground), location: 0.56),
                .init(color: .clear, location: 0.68),
                .init(color: Color(.systemBackground), location: 0.8),
                .init(color: .clear, location: 0.88),
                .init(color: Color(.systemBackground), location: 1)
            ]
        )
    @State var spinAmount: Double = 1
    var body: some View {
        Group {
            Image(.wiidisc)
                .resizable()
                .scaledToFit()
                .overlay {
                    GeometryReader { geo in
                        Circle()
                            .fill(
                                AngularGradient(
                                    gradient: gradient,
                                    center: .center,
                                    angle: .degrees(-90)
                                )
                            )
                            .opacity(0.4)
                    }
                }
        }
        //.compositingGroup()
        //.rotation3DEffect(Angle(degrees: spin), axis: (0, 1, 0))
        .scaleEffect(x: spinAmount)
        .task {
            if (spin && UserDefaults.standard.bool(forKey: "themeAnimations") == true) {
                withAnimation(.easeInOut(duration: 3).delay(2).repeatForever(autoreverses: true)) {
                    spinAmount = -1
                }
            }
        }
        
    }
}

struct wiidisc: View {
    var animated: Bool
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: geo.size.height * 0.03) {
                wiidiscalone(spin: animated)
                    .padding(.top, geo.size.height * 0.08)
                    .frame(height: geo.size.height * 0.85)
                wiidiscalone(spin: animated)
                    .frame(height: geo.size.height * 0.85)
                    .opacity(0.6)
            }
                .frame(maxWidth: min(geo.size.width, geo.size.height), maxHeight: min(geo.size.width, geo.size.height), alignment: .top)
                .clipped()
        }
            .aspectRatio(1, contentMode: .fit)
            .mask {
                if (1 == 1) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .black, location: 0),
                                    .init(color: .black, location: 0.9),
                                    .init(color: .clear, location: 1),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
    }
}

#Preview {
    wiidisc(animated: true)
}

#Preview {
    ZStack {
        wiidisc(animated: true)
            .border(.red)
        Rectangle().fill(.red).frame(height: 2)
    }
}

#Preview {
    HStack {
        wiidisc(animated: true)
            .padding(20)
        //Spacer()
        Text("asajsdasdasdn")
        Spacer()
        Text("asajsdnasjidasndaosnd")
    }
}

//#Preview {
//    ContentView(currentTheme: "wii")
//        .environment(PlayerManager())
//}
