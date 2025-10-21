//
//  ImportTrackFile.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-09.
//

import SwiftUI

struct ImportFileTrack: View {
    @Environment(DownloadManager.self) var downloadManager
    @Binding var presentImporter: Bool
    @Binding var track: FetchedTrack
    @State var isDownloadingTrack: Bool = false
    @Binding var rawFileURL: URL
    @Environment(BackgroundDatabase.self) private var database
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Track ID") {
                    TextField("Unique Track ID...", text: $track.TrackID)
                }
                Section("Track Title") {
                    TextField("Track Title...", text: $track.Title)
                }
                Section("Features") {
                    List {
                        ForEach($track.Features, id: \.self, editActions: .delete) { $artist in
                            NavigationLink(artist.Name, destination: ImportFileArtist(artist: $artist))
                        }
                        HStack {
                            Text("Add Artist")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button(action: {
                                track.Features.append(SearchedArtist())
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.headline)
                            }
                        }
                            .deleteDisabled(true)
                    }
                }
                
                NavigationLink("Album...", destination: ImportFileAlbum(track: $track))
                
                Section("Index in Album") {
                    Picker("Index in Album...", selection: $track.Index) {
                        ForEach(1...1000, id: \.self) {
                            Text(String($0))
                        }
                    }
                        .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Edit Metadata")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isDownloadingTrack = true
                        
                        // Download Track
                        let playbackID: String = UUID().uuidString
                        let fileManager = FileManager.default
                        let destinationDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let destinationFileName = "Audio-\(playbackID).mp4"
                        track.Playback_Clean = playbackID
                        let destinationURL = destinationDirectory.appendingPathComponent(destinationFileName)
                        do {
                            // If the file already exists at the destination, remove it (optional)
                            if fileManager.fileExists(atPath: destinationURL.path) {
                                try fileManager.removeItem(at: destinationURL)
                            }
                            
                            // Copy the file from the source URL to the destination URL
                            try fileManager.copyItem(at: rawFileURL, to: destinationURL)
                            print("File saved: \(destinationURL)")
                            
                            // Add Track to Library
                            Task {
                                await database.insert(StoredTrack(from: track))
                                try? database.save()
                            }
                            
                            presentImporter = false
                            
                        } catch {
                            print("Error saving file: \(error)")
                        }
                    }) {
                        Text(isDownloadingTrack ? "Saving..." : "Save to Library")
                    }
                        .disabled(isDownloadingTrack)
                }
            }
            .scrollContentBackground(.hidden)
            .background {
                GlobalBackground_component()
            }
        }
    }
}
