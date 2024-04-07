//
//  AlbumContentButtons_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-07.
//

import SwiftUI

struct AlbumWideButton_wii: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(FontManager.self) var fontManager
    var text: String
    var subtitle: String?
    var ArtworkID: String
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(text)
                if (!networkMonitor.isConnected && subtitle != nil) {
                    Text(subtitle!)
                        .customFont(fontManager, .caption2)
                        .foregroundStyle(.secondary)
                }
            }
                .foregroundStyle(.primary)
            Spacer()
        }
            .customFont(fontManager, .body)
            .padding(10)
            .background {
                ZStack {
                    Image(.wiibutton)
                        .resizable()
                    Capsule(style: .continuous).fill(.clear)
                    //RoundedRectangle(cornerRadius: 10).fill(.clear)
                        .stroke(.wiiborder, lineWidth: 4)
                        //.stroke(colorScheme == .light ? Color(red: 0.5450980392, green: 0.8, blue: 0.8784313725490196) : Color(red: 0.1607843137254902, green: 0.24313725490196078, blue: 0.34509803921568627), lineWidth: 4)
                }
            }
            .clipShape(Capsule(style: .continuous))
            
    }
}

#Preview {
    Button(action: {}) {
        AlbumWideButton_wii(text: "Play", ArtworkID: SearchedAlbum(default: true).Artwork)
    }
        .buttonStyle(.plain)
        .environment(NetworkMonitor())
}
