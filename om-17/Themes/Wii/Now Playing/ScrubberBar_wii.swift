//
//  ScrubberBar_wii.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-02.
//

import SwiftUI
import SwiftData

struct ScrubberBar_wii: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDragging: Bool
    @Binding var width: CGFloat
    var currentNormal: CGFloat
    var pressedNormal: CGFloat
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // background bar
                ZStack {
                    Rectangle()
                        .frame(width: width, height: 13)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(colorScheme == .dark ? 0.4 : 0.2)
                        .blendMode(.overlay)
                    Rectangle()
                        .frame(width: width, height: 13)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(colorScheme == .dark ? 0.1 : 0.4)
                }
                // current elapsed bar
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: currentNormal, height: 13)
                            .foregroundStyle(colorScheme == .dark ? Color(red: 0, green: 0.51, blue: 0.75) : Color(red: 0.39, green: 0.88, blue: 1))
                            .opacity(0.8)
                        Rectangle()
                            .frame(width: currentNormal, height: 13)
                            .foregroundStyle(colorScheme == .dark ? .black : .black)
                            .opacity(0.2)
                            .blur(radius: 15)
                    }
                        //.opacity(self.isDragging ? 0.3 : 0.45)
                    Spacer(minLength: 0)
                }
                // pressed scrubbing bar
                if (self.isDragging) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: pressedNormal, height: 13)
                                .foregroundStyle(colorScheme == .dark ? Color(red: 0, green: 0.66, blue: 0.98) : Color(red: 0.39, green: 0.88, blue: 1))
                                .opacity(0.8)
                            Rectangle()
                                .frame(width: pressedNormal, height: 13)
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .opacity(0.2)
                                .blur(radius: 15)
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .onAppear {
                    self.width = geo.size.width
                }
                .onChange(of: geo.size.width) {
                    self.width = geo.size.width
                }
        }
            .frame(height: 13)
    }
}

#Preview {
    @Previewable @AppStorage("currentTheme") var currentTheme: String = "classic"
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return NowPlayingSheet(showingNPSheet: .constant(true), passedNSPath: .constant(NavigationPath()))
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .task {
            currentTheme = "wii"
        }
}
