//
//  LibraryTab.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct LibraryTab: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding var libraryNSPath: NavigationPath
    @State private var tabbarHeight: CGFloat = 0
    var body: some View {
        ZStack {
            LibraryPage(libraryNSPath: $libraryNSPath)
                .overlay {
                    VStack {
                        Spacer()
                        TabbarBackground_component(tabbarHeight: $tabbarHeight)
                    }
                        .ignoresSafeArea()
                }
            VStack {
                Spacer()
                GeometryReader { geo in
                    Rectangle().fill(.clear)
                        .onAppear {
                            tabbarHeight = UIScreen.main.bounds.height - geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) {
                            tabbarHeight = UIScreen.main.bounds.height - geo.frame(in: .global).minY
                        }
                }
                .frame(height: 1)
            }
            MiniPlayer(passedNSPath: $libraryNSPath)
        }
            .toolbarBackground(.hidden, for: .tabBar)
    }
}
