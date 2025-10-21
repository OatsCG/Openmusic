//
//  SearchTab.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct SearchTab: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding var searchNSPath: NavigationPath
    @Binding var tabbarHeight: CGFloat
    
    var body: some View {
        ZStack {
            SearchPage(searchNSPath: $searchNSPath)
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
            MiniPlayer(passedNSPath: $searchNSPath)
        }
            .toolbarBackground(.hidden, for: .tabBar)
    }
}
