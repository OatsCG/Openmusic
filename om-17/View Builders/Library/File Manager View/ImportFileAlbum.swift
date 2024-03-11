//
//  ImportFileAlbum.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI
import PhotosUI

struct ImportFileAlbum: View {
    @Binding var track: FetchedTrack
    @State var artworkItem: PhotosPickerItem? = nil
    var body: some View {
        NavigationStack {
            Form {
                Section("Album ID") {
                    TextField("Unique Album ID...", text: $track.Album.AlbumID)
                }
                
                Section("Artwork") {
                    HStack {
                        PhotosPicker("Choose Photo...", selection: $artworkItem, matching: .images)
                            .photosPickerStyle(.presentation)
                        Spacer()
                        AlbumArtDisplay(ArtworkID: track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 5)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                        .onChange(of: artworkItem) {
                            Task {
                                if let loaded = try? await artworkItem?.loadTransferable(type: Data.self) {
                                    if let contentType = artworkItem?.supportedContentTypes.first {
                                        let url = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
                                        do {
                                            try loaded.write(to: url)
                                            self.track.Album.Artwork = UUID().uuidString
                                            let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Artwork-\(self.track.Album.Artwork).jpg")
                                            try loaded.write(to: destinationURL ?? url, options: .atomic)
                                            print(url.absoluteString)
                                        } catch {
                                            print("Failed")
                                        }
                                    }
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                }
                
                Section("Title") {
                    TextField("Album Title...", text: $track.Album.Title)
                }
                
                Section("Artists") {
                    List {
                        ForEach($track.Album.Artists, id: \.self, editActions: .delete) { $artist in
                            NavigationLink(artist.Name, destination: ImportFileArtist(artist: $artist))
                        }
                        HStack {
                            Text("Add Artist")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button(action: {
                                track.Album.Artists.append(SearchedArtist())
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.headline)
                            }
                        }
                            .deleteDisabled(true)
                    }
                }
                
                Section("Release Year") {
                    Picker("Release Year...", selection: $track.Album.Year) {
                        ForEach(1600...2100, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
                .navigationTitle("Edit Album")
        }
        .scrollContentBackground(.hidden)
        .background {
            GlobalBackground_component()
        }
    }
}

//#Preview {
//    ImportFileAlbum()
//}
