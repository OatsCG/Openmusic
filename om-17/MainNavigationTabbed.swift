//
//  MainNavigationTabbed.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-17.
//

import SwiftUI

struct MainNavigationTabbed: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(FontManager.self) private var fontManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @Binding var exploreNSPath: NavigationPath
    @Binding var searchNSPath: NavigationPath
    @Binding var libraryNSPath: NavigationPath
    @Binding var tabbarHeight: CGFloat
    @Binding var selectionBinding: Int
    var body: some View {
        ZStack {
            TabView(selection: $selectionBinding) {
                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    .tag(0)
                SearchTab(searchNSPath: $searchNSPath, tabbarHeight: $tabbarHeight)
                    .tag(1)
                LibraryTab(libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight)
                    .tag(2)
                SettingsTab()
                    .tag(3)
                
            }
                //.safeAreaPadding(.bottom, 130)
            TabIcons(selectionBinding: $selectionBinding, tabbarHeight: $tabbarHeight)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .customFont(fontManager, .subheadline)
        .tint(GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme))
        .preferredColorScheme(activeAppearance(theme: currentTheme, appearance: Appearance(rawValue: preferredAppearance)))
        .onOpenURL { url in
            print("URL FOUND")
            let components: [String] = url.pathComponents
            //   openmusicapp://open/album/\(encodedAlbum!)
            //   components = ["/", "album", "encodedAlbum"]
            let type = components[1]
            if type == "album" {
                let encodedAlbum = components[2]
                let album: SearchedAlbum? = decodeURLSafeStringToAlbum(encodedString: encodedAlbum)
                if album != nil {
                    if self.selectionBinding != 0 {
                        self.selectionBinding = 0
                    }
                    exploreNSPath.append(SearchAlbumContentNPM(album: album!))
                    ToastManager.shared.propose(toast: Toast.linkopened())
                } else {
                    ToastManager.shared.propose(toast: Toast.linkopenfailed())
                }
            }
        }
    }
}
