//
//  ContentView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-05.
//


import SwiftUI
import SwiftData
//142.189.12.151

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(FontManager.self) private var fontManager
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @State var selections: (Int, Int) = (-1, 0) // (previous, current)
    @State private var exploreNSPath = NavigationPath()
    @State private var searchNSPath = NavigationPath()
    @State private var libraryNSPath = NavigationPath()
    @State var tabbarHeight: CGFloat = 100
    var selectionBinding: Binding<Int> { Binding(
        get: {
            self.selections.1
        },
        set: {
            self.selections = (self.selections.1, $0)
            if (self.selections.0 == self.selections.1) {
                print("Pop to root view for first tab!!")
                if (self.selections.1 == 0) {
                    exploreNSPath = NavigationPath()
                } else if (self.selections.1 == 1) {
                    searchNSPath = NavigationPath()
                } else if (self.selections.1 == 2) {
                    libraryNSPath = NavigationPath()
                }
            }
        }
    )}
    @State private var selectedCategoryId: MenuItem.ID?
    private var dataModel = splitviewModel()
    
    
    init() {
        //UITabBar.appearance().unselectedItemTintColor = UIColor.red
        UITabBar.appearance().standardAppearance.stackedLayoutAppearance.normal.iconColor = .red
    }
    
    var body: some View {
        if (horizontalSizeClass == .regular && verticalSizeClass == .regular) {
        //if (1 == 2) {
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
                TabView(selection: selectionBinding) {
                    NavigationStack {
                        ExploreTab(exploreNSPath: $exploreNSPath, tabbarHeight: $tabbarHeight)
                    }
                        .tag(0)
                        .toolbar(.hidden, for: .tabBar)
                    NavigationStack {
                        SearchTab(searchNSPath: $searchNSPath, tabbarHeight: $tabbarHeight)
                    }
                        .tag(1)
                        .toolbar(.hidden, for: .tabBar)
                    NavigationStack {
                        LibraryTab(libraryNSPath: $libraryNSPath, tabbarHeight: $tabbarHeight)
                    }
                        .tag(2)
                        .toolbar(.hidden, for: .tabBar)
                    NavigationStack {
                        SettingsTab()
                    }
                        .tag(3)
                        .toolbar(.hidden, for: .tabBar)
                }
                .onChange(of: selectedCategoryId) {
                    switch selectedCategoryId {
                    case dataModel.mainMenuItems[0].id:
                        selectionBinding.wrappedValue = 0
                    case dataModel.mainMenuItems[1].id:
                        selectionBinding.wrappedValue = 1
                    case dataModel.mainMenuItems[2].id:
                        selectionBinding.wrappedValue = 2
                    case dataModel.mainMenuItems[3].id:
                        selectionBinding.wrappedValue = 3
                    case .none:
                        selectionBinding.wrappedValue = 0
                    case .some(_):
                        selectionBinding.wrappedValue = 0
                    }
                }
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
                        if self.selectionBinding.wrappedValue != 0 {
                            self.selectionBinding.wrappedValue = 0
                        }
                        exploreNSPath.append(SearchAlbumContentNPM(album: album!))
                        ToastManager.shared.propose(toast: Toast.linkopened())
                    } else {
                        ToastManager.shared.propose(toast: Toast.linkopenfailed())
                    }
                }
            }
        } else {
            ZStack {
                TabView(selection: selectionBinding) {
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
                TabIcons(selectionBinding: selectionBinding, tabbarHeight: $tabbarHeight)
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
                        if self.selectionBinding.wrappedValue != 0 {
                            self.selectionBinding.wrappedValue = 0
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



#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ContentView()
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "classic"
            globalIPAddress = "server.openmusic.app"
        }
}
