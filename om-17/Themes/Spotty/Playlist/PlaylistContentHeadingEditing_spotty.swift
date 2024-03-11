//
//  PlaylistContentHeadingEditing_spotty.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-16.
//

import SwiftUI

struct PlaylistContentHeadingEditing_spotty: View {
    var playlist: StoredPlaylist
    @State private var title: String = "pre1"
    @State private var bio: String = "these are my favourite songs!"
    var body: some View {
        VStack {
            PlaylistArtDisplay(playlist: playlist, Blur: 30, BlurOpacity: 0.6, cornerRadius: 8.0)
                .padding([.bottom], 8)
            VStack {
                TextField(text: $title, prompt: Text("Playlist Title"), label: {
                    Label("label text", systemImage: "circle")
                })
                .customFont(.title, bold: true)
                .foregroundBlur(playlist: playlist)
                .border(.secondary)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
                .onChange(of: title) {
                    playlist.Title = title
                }
                TextField(text: $bio, prompt: Text("Description"), label: {
                    Label("label text", systemImage: "circle")
                })
                .customFont(.headline)
                .foregroundBlur(playlist: playlist, fade: 0.5)
                .border(.secondary)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
                .onChange(of: bio) {
                    playlist.Bio = bio
                }
            }
                .scrollDismissesKeyboard(.interactively)
            //.formStyle(.columns)
            
        }
            .multilineTextAlignment(.center)
            .onAppear(perform: {
                self.title = playlist.Title
                self.bio = playlist.Bio
            })
    }
}
