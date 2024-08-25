//
//  FileManagerView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI
import SwiftData
import AVFoundation

struct FileManagerView: View {
    @State private var presentFiles = false
    @State private var presentImporter = false
    @State private var fileTrack: FetchedTrack = FetchedTrack()
    @State private var rawFileURL: URL = .applicationDirectory
    var body: some View {
        Form {
            Section("Manage Downloads") {
                NavigationLink(value: ManageAudiosNPM()) {
                    Text("Audios")
                }
                NavigationLink(value: ManageImagesNPM()) {
                    Text("Images")
                }
            }
            
            Button(action: {
                presentFiles = true
            }) {
                Text("Import File...")
            }
            .fileImporter(isPresented: $presentFiles, allowedContentTypes: [.audiovisualContent]) { result in
                switch result {
                case .success(let url):
                    guard url.startAccessingSecurityScopedResource() else {
                        print("no permissions!!")
                        return
                    }
                    print(url)
                    rawFileURL = url
                    //self.fileURLToImport = url
                    let asset = AVURLAsset(url: url)
                    Task {
                        self.fileTrack = await get_metadata(asset: asset)
                        self.presentImporter = true
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .sheet(isPresented: $presentImporter, content: {
                ImportFileTrack(presentImporter: $presentImporter, track: self.$fileTrack, rawFileURL: $rawFileURL)
            })
        }
        .navigationTitle("File Manager")
        .safeAreaPadding(.bottom, 80)
        .scrollContentBackground(.hidden)
        .background {
            GlobalBackground_component()
        }
    }
}

func get_metadata(asset: AVAsset) async -> FetchedTrack {
    var track: FetchedTrack = FetchedTrack()
    let trackDuration: CMTime? = try? await asset.load(.duration)
    track.Length = Int(trackDuration?.seconds ?? .nan)
    do {
        let metadata = try await asset.load(.metadata)
        
        let dataItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle)
        if let item = dataItems.first {
            if let value = item.value(forKey: "value") as? String {
                track.Title = value
            }
        }
        
        let dataItems2 = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist)
        if let item = dataItems2.first {
            if let value = item.value(forKey: "value") as? String {
                var searchedArtist: SearchedArtist = SearchedArtist()
                searchedArtist.Name = value
                track.Album.Artists = [searchedArtist]
            }
        }
        
        let dataItems3 = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierAlbumName)
        if let item = dataItems3.first {
            if let value = item.value(forKey: "value") as? String {
                track.Album.Title = value
            }
        }
        
        let dataItems4 = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork)
        if let item = dataItems4.first {
            if let value = item.value(forKey: "value") as? Data {
                // download image
                let artworkID: String = UUID().uuidString
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileName = "Artwork-\(artworkID).jpg"
                let fileURL = directory.appendingPathComponent(fileName)
                do {
                    try value.write(to: fileURL)
                    track.Album.Artwork = artworkID
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    } catch {
        print("catastrophy!")
        print(error)
    }
    return track
}


#Preview {
    FileManagerView()
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    //let playlist = StoredPlaylist(Title: "Test!")
    return LibraryPage(libraryNSPath: .constant(NavigationPath()))
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .environment(OMUser())
        .modelContainer(container)
}
