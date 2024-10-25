//
//  VibeView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-20.
//

import SwiftUI

struct VibeView: View {
    @Environment(FontManager.self) private var fontManager
    @Environment(PlayerManager.self) var playerManager
    var vibe: VibeObject
    @State var tapping: VibeTap = .cancel
    @State var didClick: Int = 0
    var body: some View {
        Button(action: {
            tapping = .stop
            didClick += 1
            if playerManager.currentVibe != vibe {
                playerManager.setCurrentVibe(vibe: vibe)
            } else {
                playerManager.clearVibe()
            }
        }) {
            HStack {
                VStack(alignment: .center) {
                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white.secondary)
                        .symbolEffect(.bounce, value: didClick)
                }
                VStack(alignment: .leading) {
                    Text(vibe.title)
                        .customFont(fontManager, .headline, bold: true)
                    Text(vibe.genre.uppercased())
                        .customFont(fontManager, .subheadline, bold: true)
                        .foregroundStyle(.white.secondary)
                }
                Spacer()
                if playerManager.currentVibe == vibe {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white.secondary)
                        .font(.title2)
                }
            }
                .foregroundStyle(.white)
                .frame(width: 220, height: 45)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    VibeBackground(mainHue: Double(vibe.hue), tapping: $tapping)
                }
        }
        .buttonStyle(CustomButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    tapping = .start
                }
                .onEnded { _ in
                    if tapping == .start {
                        tapping = .cancel
                    }
                }
        )
//        .buttonStyle(CustomButtonStyle(onPressed: {
//            tapping = .start
//        }, onReleased: {
//            tapping = .cancel
//        }))
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


struct VibeBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var seed: UUID
    @Binding var tapping: VibeTap
    @State var mainHue: Double
    @State var leftPosY: Float
    @State var leftPosYStatic: Float
    @State var leftPosYAlt: Float
    @State var rightPosY: Float
    @State var rightPosYStatic: Float
    @State var rightPosYAlt: Float
    @State var kHueDiff: Double
    @State var jHueDiff: Double
    @State var mHueDiff: Double
    @State var nHueDiff: Double
    @State var saturationAdditive: Double
    init(mainHue: Double, tapping: Binding<VibeTap>) {
        self.seed = UUID()
        self._tapping = tapping
        let r = Random(seed)
        self.mainHue = mainHue
        let lefty: Float = Float(r.next()) * 0.9
        self.leftPosY = lefty
        self.leftPosYStatic = lefty
        self.leftPosYAlt = Float(mod(Double(lefty) + 0.5, 1))
        let righty: Float = Float(r.next()) * 0.9
        self.rightPosY = righty
        self.rightPosYStatic = righty
        self.rightPosYAlt = Float(mod(Double(righty) + 0.5, 1))
        self.kHueDiff = (r.next() * 0.1) - 0.05
        self.jHueDiff = (r.next() * 0.1) - 0.05
        self.mHueDiff = (r.next() * 0.2) - 0.1
        self.nHueDiff = (r.next() * 0.2) - 0.1
        self.saturationAdditive = 0
    }
    var body: some View {
        let k: Color = Color(hue: mainHue + kHueDiff, saturation: 0.5 + saturationAdditive, brightness: colorScheme == .dark ? 0.7 : 0.85)
        let j: Color = Color(hue: mainHue + jHueDiff, saturation: 0.8 + saturationAdditive, brightness: colorScheme == .dark ? 0.7 : 0.85)
        let m: Color = Color(hue: mainHue + mHueDiff, saturation: 0.8 + saturationAdditive, brightness: colorScheme == .dark ? 0.7 : 0.85)
        let n: Color = Color(hue: mainHue + nHueDiff, saturation: 0.8 + saturationAdditive, brightness: colorScheme == .dark ? 0.7 : 0.85)
        RoundedRectangle(cornerRadius: 15)
            .fill(
                MeshGradient(
                    width: 4,
                    height: 3,
                    points: [
                        [0, 0], [0.33, 0], [0.66, 0], [1, 0],
                        [0, 0.5], [0.2, leftPosY], [0.8, rightPosY], [1, 0.5],
                        [0, 1], [0.33, 1], [0.66, 1], [1, 1]
                    ],
                    colors: [
                        k, k, k, k,
                        k, m, n, k,
                        j, j, j, j
                    ]
                )
            )
            .onChange(of: tapping) { old, new in
                if new == .start {
                    withAnimation(.interactiveSpring(duration: 0.25, extraBounce: 0.06)) {
//                        leftPosY = self.leftPosYStatic
//                        rightPosY = self.rightPosYStatic
                        saturationAdditive = 0.2
                    }
                } else if new == .stop {
                    withAnimation(.interactiveSpring(duration: 0.4, extraBounce: 0.3)) {
                        leftPosY = Float(mod(Double(leftPosY) + 0.5, 1))
                        rightPosY = Float(mod(Double(rightPosY) + 0.5, 1))
                        saturationAdditive = 0
                    }
                } else {
                    withAnimation(.interactiveSpring(duration: 0.9)) {
//                        leftPosY = self.leftPosYStatic
//                        rightPosY = self.rightPosYStatic
                        saturationAdditive = 0
                    }
                }
            }
    }
}

enum VibeTap {
    case start, stop, cancel
}



//#Preview {
//    ScrollView(.horizontal) {
//        HStack {
//            ForEach(0..<6) { i in
//                VibeView(vibe: VibeObject())
//            }
//        }
//        .safeAreaPadding()
//    }
//}
