//
//  TabIcons.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-14.
//

import SwiftUI

struct TabIcons: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(FontManager.self) private var fontManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @Binding var selectionBinding: Int
    @Binding var tabbarHeight: CGFloat
    @State var homebarMin: CGFloat = 10
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Button(action: {selectionBinding = 0}) {
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "globe")
                            .fontWeight(.medium)
                            .font(.title2)
                        Text("Home")
                            .customFont(fontManager, .caption2)
                    }
                }
                .allowsHitTesting(false)
                .buttonStyle(.plain)
                .foregroundColor(selectionBinding == 0 ? GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme) : Color.secondary)
                //.blendMode(selectionBinding == 0 ? .overlay : .normal)
                Spacer()
                Spacer()
                Button(action: {selectionBinding = 1}) {
                    //TabBarSearchLabel_component(selectionBinding: $selectionBinding)
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "magnifyingglass")
                            .fontWeight(.medium)
                            .font(.title2)
                        Text("Search")
                            .customFont(fontManager, .caption2)
                    }
                }
                .allowsHitTesting(false)
                .buttonStyle(.plain)
                .foregroundColor(selectionBinding == 1 ? GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme) : Color.secondary)
                //.blendMode(selectionBinding == 0 ? .overlay : .normal)
                Spacer()
                Spacer()
                Button(action: {selectionBinding = 2}) {
                    //TabBarLibraryLabel_component(selectionBinding: $selectionBinding)
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "music.note.list")
                            .fontWeight(.medium)
                            .font(.title2)
                        Text("Library")
                            .customFont(fontManager, .caption2)
                    }
                }
                .allowsHitTesting(false)
                .buttonStyle(.plain)
                .foregroundColor(selectionBinding == 2 ? GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme) : Color.secondary)
                //.blendMode(selectionBinding == 0 ? .colorDodge : .normal)
                Spacer()
                Spacer()
                Button(action: {selectionBinding = 3}) {
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "gear")
                            .fontWeight(.medium)
                            .font(.title2)
                        Text("Options")
                            .customFont(fontManager, .caption2)
                    }
                }
                .allowsHitTesting(false)
                .buttonStyle(.plain)
                .foregroundColor(selectionBinding == 3 ? GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme) : Color.secondary)
                //.blendMode(selectionBinding == 0 ? .softLight : .normal)
                Spacer()
            }
                .frame(height: max(tabbarHeight - max(homebarMin - 5, 0), 0))
                .padding(.bottom, max(homebarMin - 5, 0))
        }
        .ignoresSafeArea()
        .overlay {
            VStack {
                Spacer()
                GeometryReader { geo in
                    Rectangle().fill(.clear)
                        .onAppear {
                            homebarMin = UIScreen.main.bounds.height - geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) {
                            homebarMin = UIScreen.main.bounds.height - geo.frame(in: .global).minY
                        }
                }
                .frame(height: 1)
            }
        }
    }
}


