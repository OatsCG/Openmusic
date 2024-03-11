//
//  PlaylistBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI
import SwiftData

struct PlaylistBackground_wii: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var yoffset: Double = 0
    var playlist: Playlist
    var body: some View {
        ZStack {
            if (colorScheme == .dark) {
                Color.black
            } else {
                Color.white
            }
            GeometryReader { geo in
                VStack(spacing: 1) {
                    ForEach((1...(Int((geo.size.height <= 20 ? 30 : geo.size.height)) / 10)), id: \.self) {_ in
                        Rectangle().fill(.quinary)
                            .opacity(0.4)
                            .frame(width: geo.size.width, height: 10)
                            .offset(y: yoffset)
                        
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)
                    .repeatForever(autoreverses: false)) {
                        //yoffset = -11
                    }
            })
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    return PlaylistBackground_classic(playlist: playlist)
        .modelContainer(container)
}
