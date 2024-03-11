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
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @State var selections: (Int, Int) = (-1, 0) // (previous, current)
    @State private var exploreNSPath = NavigationPath()
    @State private var searchNSPath = NavigationPath()
    @State private var libraryNSPath = NavigationPath()
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
    var body: some View {
        //if (horizontalSizeClass == .regular && verticalSizeClass == .regular) {
        if (1 == 2) {
            NavigationSplitView(columnVisibility: .constant(.automatic)) {
                List(dataModel.mainMenuItems, selection: $selectedCategoryId) { item in
                    HStack {
                        Image(systemName: item.image)
                            .symbolRenderingMode(.hierarchical)
                        Text(item.name)
                    }
                }
                    .navigationTitle("Coffee")
            } detail: {
                switch selectedCategoryId {
                case dataModel.mainMenuItems[0].id:
                    ExplorePage(exploreNSPath: $exploreNSPath)
                        .tabItem {
                            Image(systemName: "globe")
                            Text("Explore")
                        }
                        .tag(0)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.thinMaterial, for: .tabBar)
                case dataModel.mainMenuItems[1].id:
                    SearchPage(searchNSPath: $searchNSPath)
                        .tabItem {
                            TabBarSearchLabel_component()
                        }
                        .tag(1)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.thinMaterial, for: .tabBar)
                case dataModel.mainMenuItems[2].id:
                    LibraryPage(libraryNSPath: $libraryNSPath)
                        .tabItem {
                            TabBarLibraryLabel_component()
                        }
                        .tag(2)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.thinMaterial, for: .tabBar)
                case dataModel.mainMenuItems[3].id:
                    SettingsPage()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Options")
                        }
                        .tag(3)
                case .none:
                    ExplorePage(exploreNSPath: $exploreNSPath)
                        .tabItem {
                            Image(systemName: "globe")
                            Text("Explore")
                        }
                        .tag(0)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.thinMaterial, for: .tabBar)
                case .some(_):
                    ExplorePage(exploreNSPath: $exploreNSPath)
                        .tabItem {
                            Image(systemName: "globe")
                            Text("Explore")
                        }
                        .tag(0)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.thinMaterial, for: .tabBar)
                }
            }
        } else {
            TabView(selection: selectionBinding) {
                ExplorePage(exploreNSPath: $exploreNSPath)
                    .tabItem {
                        Image(systemName: "globe")
                        Text("Home")
                    }
                    .tag(0)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(.thinMaterial, for: .tabBar)
                SearchPage(searchNSPath: $searchNSPath)
                    .tabItem {
                        TabBarSearchLabel_component()
                    }
                    .tag(1)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(.thinMaterial, for: .tabBar)
                LibraryPage(libraryNSPath: $libraryNSPath)
                    .tabItem {
                        TabBarLibraryLabel_component()
                    }
                    .tag(2)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(.thinMaterial, for: .tabBar)
                SettingsPage()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Options")
                    }
                    .tag(3)
                
            }
            .customFont(.subheadline)
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
