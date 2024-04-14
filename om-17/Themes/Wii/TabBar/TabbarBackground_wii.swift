//
//  TabbarBackground_wii.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct TabbarBackground_wii: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @Binding var tabbarHeight: CGFloat
    var body: some View {
        ZStack {
//            VStack(spacing: 0) {
//                Spacer()
//                Rectangle().fill(.background).opacity(colorScheme == .dark ? 1 : 1)
//                    .ignoresSafeArea()
//                    .frame(height: max(Miniplayer_sizing(h: horizontalSizeClass, v: verticalSizeClass).height, 0) - 15)
//                    //.mask(LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom))
//                Rectangle().fill(.background).opacity(colorScheme == .dark ? 1 : 1)
//                    .ignoresSafeArea()
//                    .frame(height: max(tabbarHeight, 0))
//                    
//            }
            VStack {
                Spacer()
                Rectangle().fill(Color(white: colorScheme == .dark ? 0.15 : 0.97))
                    .frame(height: max(tabbarHeight, 0))
                    .ignoresSafeArea()
            }
        }
    }
}
