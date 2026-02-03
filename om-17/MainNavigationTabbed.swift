//
//  MainNavigationTabbed.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-17.
//

import SwiftUI

struct MainNavigationTabbed: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(FontManager.self) private var fontManager
    @Environment(OMUser.self) private var omUser
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @Binding var exploreNSPath: NavigationPath
    @Binding var browseNSPath: NavigationPath
    @Binding var searchNSPath: NavigationPath
    @Binding var libraryNSPath: NavigationPath
    @Binding var tabbarHeight: CGFloat
    @Binding var selectionBinding: Int
    
    var body: some View {
        ZStack {
            TabView(selection: $selectionBinding) {
                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    .tag(0)
                if NetworkManager.shared.networkService.supportedFeatures.contains(.exploreall) {
                    BrowseTab(browseNSPath: $browseNSPath, tabbarHeight: $tabbarHeight)
                        .tag(4)
                }
                SearchTab(searchNSPath: $searchNSPath, tabbarHeight: $tabbarHeight)
                    .tag(1)
                LibraryTab(libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight)
                    .tag(2)
                SettingsTab()
                    .tag(3)
                
            }
            TabIcons(selectionBinding: $selectionBinding, tabbarHeight: $tabbarHeight)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .customFont(fontManager, .subheadline)
        .tint(GlobalTint_component(currentTheme: currentTheme, colorScheme: colorScheme))
        .preferredColorScheme(activeAppearance(theme: currentTheme, appearance: Appearance(rawValue: preferredAppearance)))
        .onOpenURL { url in
            print("URL FOUND")
            let components: [String] = url.pathComponents
            //   openmusicapp://open/album/<encodedAlbum>
            //   components = ["/", "album", encodedAlbum]
            //   openmusicapp://open/discord?code=<CODE>
            //   components = ["/", "discord", CODE]
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
            } else if type == "discord" {
                if let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    if let queryItems = comps.queryItems {
                        if let codeItem = queryItems.first(where: { $0.name == "code" }) {
                            if let codeValue = codeItem.value {
                                print("Code: \(codeValue)")
                                omUser.updateDiscordCode(to: codeValue)
                                ToastManager.shared.propose(toast: Toast(artworkID: "", message: "Updated Discord ID", .systemSuccess))
                            }
                        }
                    }
                }
//                let code = components[2]
//                omUser.updateDiscordCode(to: code)
//                ToastManager.shared.propose(toast: Toast(artworkID: "", message: "Updated Discord ID", .systemSuccess))
            }
        }
    }
}
