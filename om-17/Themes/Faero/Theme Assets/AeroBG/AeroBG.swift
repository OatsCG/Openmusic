//
//  AeroBG.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-18.
//

import SwiftUI

struct AeroBG: View {
    @Environment(\.colorScheme) private var colorScheme
    var colorDark: Color = .blue
    var colorLight: Color = .mint
    @State var animatedValue1: CGFloat = 0
    @State var animatedValue2: CGFloat = 0
    @State var animatedValue3: CGFloat = 0
    @State var animatedValue4: CGFloat = 0
    var body: some View {
        VStack {
            ZStack {
                colorDark.opacity(0.1)
                // cascading rects
                Group {
                    RoundedRectangle(cornerRadius: 300)
                        .fill(LinearGradient(
                            colors: [
                                .clear,
                                .clear,
                                colorDark.opacity(0.1)
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 800, height: 800)
                        .rotationEffect(.degrees(-30 + animatedValue1))
                        .offset(x: -100, y: -100 - animatedValue1 * 4)
                    RoundedRectangle(cornerRadius: 300)
                        .fill(LinearGradient(
                            colors: [
                                .clear,
                                .clear,
                                colorDark.opacity(0.1)
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 800, height: 800)
                        .rotationEffect(.degrees(-25 + animatedValue2))
                        .offset(x: 0, y: -190 - animatedValue2 * 4)
                    RoundedRectangle(cornerRadius: 300)
                        .fill(LinearGradient(
                            colors: [
                                .clear,
                                .clear,
                                colorDark.opacity(0.1)
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 800, height: 800)
                        .rotationEffect(.degrees(-20 + animatedValue3))
                        .offset(x: 100, y: -330 - animatedValue3 * 4)
                }
                // grad circle
                Circle()
                    .fill(LinearGradient(
                        colors: [
                            .clear,
                            .clear,
                            colorLight.opacity(0.1)
                        ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                    .frame(width: 800, height: 800)
                    .rotationEffect(.degrees(-30))
                    .offset(x: 100, y: 150)
                // big circle
                Circle()
                    .fill(LinearGradient(
                        colors: [
                            .clear,
                            .clear,
                            colorDark.opacity(0.1)
                        ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                    .frame(width: 900, height: 900)
                    .rotationEffect(.degrees(50))
                    .offset(x: 350, y: -400 - animatedValue4 * 4)
                //small circles
                Group {
                    Circle()
                        .fill(LinearGradient(
                            colors: [
                                colorLight.opacity(0.08),
                                colorDark.opacity(0.03),
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-40))
                        .offset(x: -100, y: -120)
                    Circle()
                        .fill(LinearGradient(
                            colors: [
                                colorLight.opacity(0.03),
                                colorDark.opacity(0.02),
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-20))
                        .offset(x: -20, y: -160)
                    Circle()
                        .fill(LinearGradient(
                            colors: [
                                colorLight.opacity(0.03),
                                colorDark.opacity(0.02),
                            ], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-20))
                        .offset(x: 120, y: -270)
                }
                    .opacity(0)
            }
                .opacity(colorScheme == .dark ? 0.6 : 0.8)
                .animation(Animation.easeInOut(duration: 4)
                    .repeatForever(autoreverses: true), value: animatedValue1)
                .animation(Animation.easeInOut(duration: 4)
                    .repeatForever(autoreverses: true), value: animatedValue2)
                .animation(Animation.easeInOut(duration: 4)
                    .repeatForever(autoreverses: true), value: animatedValue3)
                .animation(Animation.easeInOut(duration: 4)
                    .repeatForever(autoreverses: true), value: animatedValue4)
        }
            .ignoresSafeArea()
            .onDisappear {
//                animatedValue1 = 0
//                animatedValue2 = 0
//                animatedValue3 = 0
//                animatedValue4 = 0
            }
            .task {
                if (UserDefaults.standard.bool(forKey: "themeAnimations") == true) {
                    animatedValue1 = 10
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    animatedValue2 = 10
                    try? await Task.sleep(nanoseconds: 1_400_000_000)
                    animatedValue3 = 10
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    animatedValue4 = 10
//                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(0)) {
//                        animatedValue1 = 10
//                    }
//                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1.0)) {
//                        animatedValue2 = 10
//                    }
//                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(2.4)) {
//                        animatedValue3 = 10
//                    }
//                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(3.4)) {
//                        animatedValue4 = 10
//                    }
                }
            }
    }
}

#Preview {
    @Previewable @AppStorage("themeAnimations") var themeAnimations: Bool = true
    return ScrollView {
        VStack {
            Text("hello!")
        }
    }
    .task {
        themeAnimations = true
    }
    .background {
        AeroBG()
    }
}
