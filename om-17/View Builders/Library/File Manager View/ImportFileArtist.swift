//
//  ImportFileArtist.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI

struct ImportFileArtist: View {
    @Binding var artist: SearchedArtist
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Artist ID") {
                    TextField("Unique Artist ID...", text: $artist.ArtistID)
                }
                Section("Name") {
                    TextField("Artist Name...", text: $artist.Name)
                }
            }
                .navigationTitle("Edit Artist")
        }
        .scrollContentBackground(.hidden)
        .background {
            GlobalBackground_component()
        }
    }
}
