//
//  TabbarBackground_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct TabbarBackground_faero: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @Binding var tabbarHeight: CGFloat
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle().fill(.background).opacity(colorScheme == .dark ? 0.8 : 0.7)
                    .ignoresSafeArea()
                    .frame(height: max(Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height, 0))
                    .mask(LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom))
                Rectangle().fill(.background).opacity(colorScheme == .dark ? 0.8 : 0.7)
                    .ignoresSafeArea()
                    .frame(height: max(tabbarHeight, 0))
                    
            }
            VariableBlurView()
                .ignoresSafeArea()
                .frame(height: max(tabbarHeight + Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height, 0))
        }
    }
}
