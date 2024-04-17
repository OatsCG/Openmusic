//
//  MainNavigationSidebar.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-17.
//

import SwiftUI

struct MainNavigationSidebar: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(FontManager.self) var fontManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    
    @Binding var exploreNSPath: NavigationPath
    @Binding var searchNSPath: NavigationPath
    @Binding var libraryNSPath: NavigationPath
    @Binding var tabbarHeight: CGFloat
    @Binding var selectionBinding: Int
    
    @State var selectedCategoryId: MenuItem.ID?
    var dataModel = splitviewModel()
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.automatic)) {
            List(dataModel.mainMenuItems, selection: $selectedCategoryId) { item in
                HStack {
                    Image(systemName: item.image)
                        .symbolRenderingMode(.hierarchical)
                    Text(item.name)
                }
            }
                .navigationTitle("Openmusic")
        } detail: {
            switch selectedCategoryId {
            case dataModel.mainMenuItems[0].id:
                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    .toolbar(.hidden, for: .tabBar)
            case dataModel.mainMenuItems[1].id:
                SearchTab(searchNSPath: $searchNSPath, tabbarHeight: $tabbarHeight)
                    .toolbar(.hidden, for: .tabBar)
            case dataModel.mainMenuItems[2].id:
                LibraryTab(libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight)
                    .toolbar(.hidden, for: .tabBar)
            case dataModel.mainMenuItems[3].id:
                SettingsTab()
                    .toolbar(.hidden, for: .tabBar)
            case .none:
                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    .toolbar(.hidden, for: .tabBar)
            case .some(_):
                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    .toolbar(.hidden, for: .tabBar)
            }
//            TabView(selection: $selectionBinding) {
//                ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
//                    .tag(0)
//                    .toolbar(.hidden, for: .tabBar)
//                SearchTab(searchNSPath: $searchNSPath, tabbarHeight: $tabbarHeight, selectionBinding: $selectionBinding)
//                    .tag(1)
//                    .toolbar(.hidden, for: .tabBar)
//                LibraryTab(libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight)
//                    .tag(2)
//                    .toolbar(.hidden, for: .tabBar)
//                SettingsTab()
//                    .tag(3)
//                    .toolbar(.hidden, for: .tabBar)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
        }
//        .onChange(of: selectedCategoryId) {
//            switch selectedCategoryId {
//            case dataModel.mainMenuItems[0].id:
//                selectionBinding = 0
//            case dataModel.mainMenuItems[1].id:
//                selectionBinding = 1
//            case dataModel.mainMenuItems[2].id:
//                selectionBinding = 2
//            case dataModel.mainMenuItems[3].id:
//                selectionBinding = 3
//            case .none:
//                selectionBinding = 0
//            case .some(_):
//                selectionBinding = 0
//            }
//        }
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

struct MenuItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var image: String
}

struct splitviewModel {
    let mainMenuItems = [
        MenuItem(name: "Explore", image: "globe"),
        MenuItem(name: "Search", image: "magnifyingglass"),
        MenuItem(name: "Library", image: "book"),
        MenuItem(name: "Options", image: "gear")
    ]
}

