//
//  ThemePreview_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-24.
//

import SwiftUI
import SwiftData

struct ThemePreview_classic: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        ZStack {
            ScrollView {
                // Album header
                AlbumContentHeading_classic(album: SearchedAlbum(default: true))
                    .padding(.top, -100)
                    .padding(.horizontal, 10)
                Text("•  •  •")
                    .font(.title3)
                    .padding(.vertical, 10)
                
                // Song carousel
                VStack(alignment: .leading) {
                    HStack {
                        Text("Songs")
                            .forceCustomFont(.title2, bold: true, theme: .classic)
                            .padding(.leading, 15)
                        Image(systemName: "chevron.right")
                            .symbolRenderingMode(.hierarchical)
                            .forceCustomFont(.callout, bold: true, theme: .classic)
                    }
                    ScrollView(.horizontal) {
                        HStackWrapped(rows: 2) {
                            ForEach(0...4, id: \.self) { _ in
                                SearchTrackLink_classic(track: FetchedTrack(default: true))
                                    .frame(width: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width, height: SearchTrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).height)
                            }
                        }
                            .scrollTargetLayout()
                    }
                        .scrollTargetBehavior(.viewAligned)
                        .safeAreaPadding(.horizontal, 10)
                        .scrollIndicators(.hidden)
                }
                
                // Album carousel
                VStack(alignment: .leading) {
                    HStack {
                        Text("Albums")
                            .forceCustomFont(.title2, bold: true, theme: .classic)
                            .padding(.leading, 15)
                        Image(systemName: "chevron.right")
                            .symbolRenderingMode(.hierarchical)
                            .forceCustomFont(.callout, bold: true, theme: .classic)
                    }
                    ScrollView(.horizontal) {
                        HStackWrapped(rows: 1) {
                            ForEach(0...4, id: \.self) { _ in
                                SearchAlbumLink_classic(album: SearchedAlbum(default: true))
                                    .frame(width: SearchAlbumLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).width)
                            }
                                
                        }
                            .scrollTargetLayout()
                    }
                        .scrollTargetBehavior(.viewAligned)
                        .safeAreaPadding(.horizontal, 10)
                        .scrollIndicators(.hidden)
                }
            }
            .padding(.bottom, 80)
            
            VStack {
                Spacer()
                MiniPlayer_classic()
            }
        }
        .forceCustomFont(.subheadline, theme: .classic)
            .background {
                GlobalBackground_classic()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(0.65)
        
    }
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ThemePreview_classic()
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
