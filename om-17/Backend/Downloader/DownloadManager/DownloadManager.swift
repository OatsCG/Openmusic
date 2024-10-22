//
//  DownloadManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-10.
//

import SwiftUI

@MainActor
@Observable class DownloadManager: DownloaderDelegate {
    static let shared = DownloadManager()
    let downloadActor = DownloadManagerActor()
    var tracksDownloading: [DownloadData] = []
    var downloadsCount: Int
    var sumProgression: Double = 0
    
    init() {
        self.downloadsCount = UserDefaults.standard.integer(forKey: "downloadsCount")
        self.downloadActor.downloader.delegate = self
    }
    
    
    func addDownloadTask(track: any Track, explicit: Bool) {
        Task {
            await downloadActor.addDownloadTask(track: track, explicit: explicit)
            await updateUI()
        }
    }
    
    func begin_download(downloadData: DownloadData) {
        Task {
            await downloadActor.beginDownload(downloadData: downloadData)
            await updateUI()
        }
    }
    
    func retry_download(download: DownloadData) {
        Task {
            await downloadActor.retryDownload(download: download)
            await updateUI()
        }
    }
    
    func try_next_download() {
        Task {
            await downloadActor.tryNextDownload()
            await updateUI()
            
        }
    }
    
    func updateUI() async {
        tracksDownloading = await downloadActor.tracksDownloading
        sumProgression = await downloadActor.get_sum_progression()
    }
}


// MANAGING DOWNLOADED CONTENT
extension DownloadManager {
    func gather_downloaded_audios() -> [FetchedTrack] {
        var toReturn: [FetchedTrack] = []
        // .Title = file name
        // .Views = date epoch
        // .TrackID = date string
        // .Playback_Clean = file path
        let basePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let basePath = basePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: basePath.path())
                for file in files {
                    do {
                        var track = FetchedTrack(default: true)
                        track.Title = file.lastPathComponent
                        let destination: String = basePath.appendingPathComponent(file).path()
                        track.Playback_Clean = destination
                        let attributes = try FileManager.default.attributesOfItem(atPath: destination)
                        let creationDate: Date? = attributes[.creationDate] as? Date
                        if let creationDate = creationDate {
                            track.Views = Int(creationDate.timeIntervalSinceNow.magnitude)
                            track.TrackID = creationDate.formatted(date: .abbreviated, time: .omitted)
                        }
                        if file.lastPathComponent.contains("Audio-") {
                            toReturn.append(track)
                        }
                    } catch {
                        
                    }
                }
            } catch {
                
            }
        }
        return toReturn.sorted(by: { $0.Views < $1.Views })
    }
    
    func gather_downloaded_images() -> [FetchedTrack] {
        var toReturn: [FetchedTrack] = []
        let basePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let basePath = basePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: basePath.path())
                for file in files {
                    do {
                        var track = FetchedTrack(default: true)
                        track.Title = file.lastPathComponent
                        let destination: String = basePath.appendingPathComponent(file).path()
                        let attributes = try FileManager.default.attributesOfItem(atPath: destination)
                        let creationDate: Date? = attributes[.creationDate] as? Date
                        if let creationDate = creationDate {
                            track.Views = Int(creationDate.timeIntervalSinceNow.magnitude)
                            track.TrackID = creationDate.formatted(date: .abbreviated, time: .omitted)
                        }
                        if file.lastPathComponent.contains("Artwork-") || file.lastPathComponent.contains("Playlist-") {
                            toReturn.append(track)
                        }
                    } catch {
                        print("big error")
                        print(error)
                    }
                }
            } catch {
                
            }
        }
        return toReturn.sorted(by: { $0.Views < $1.Views })
    }
    
    func filter_downloaded<T: Track>(_ tracks: [T]) async -> [T] {
        var downloadedTracks: [T] = []
        for track in tracks {
            if await self.is_downloaded(track) {
                downloadedTracks.append(track)
            }
        }
        return downloadedTracks
    }
    func filter_downloaded(_ tracks: [PlaylistItem]) async -> [PlaylistItem] {
        var downloadedTracks: [PlaylistItem] = []
        for item in tracks {
            if await self.is_downloaded(item.track) {
                downloadedTracks.append(item)
            }
        }
        return(downloadedTracks)
    }
    
    func is_playback_downloaded(PlaybackID: String?) async -> Bool {
        return await downloadActor.isPlaybackDownloaded(playbackID: PlaybackID)
    }
    
    func is_downloaded(_ track: any Track, explicit: Bool? = nil) async -> Bool {
        if explicit == nil {
            if track.Playback_Explicit != nil {
                return await is_playback_downloaded(PlaybackID: track.Playback_Explicit)
            } else {
                return await is_playback_downloaded(PlaybackID: track.Playback_Clean)
            }
        } else {
            if explicit == true {
                return await self.is_playback_downloaded(PlaybackID: track.Playback_Explicit)
            } else {
                return await is_playback_downloaded(PlaybackID: track.Playback_Clean)
            }
        }
    }
    func is_downloaded(_ queueItem: QueueItem, explicit: Bool? = nil) async -> Bool {
        if explicit == nil {
            if queueItem.Track.Playback_Explicit != nil {
                return await is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Explicit)
            } else {
                return await is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Clean)
            }
        } else {
            if explicit == true {
                return await is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Explicit)
            } else {
                return await is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Clean)
            }
        }
    }
    
    func are_playbacks_downloaded(PlaybackIDs: [String]) async -> Bool {
        for playbackID in PlaybackIDs {
            if await is_playback_downloaded(PlaybackID: playbackID) == false {
                return false
            }
        }
        return true
    }
    
    func get_stored_location(PlaybackID: String) -> URL {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("Audio-\(PlaybackID).mp4")
        return(destinationUrl!)
    }
    
    func delete_playback(PlaybackID: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("Audio-\(PlaybackID).mp4")
        
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
            } catch let error {
                print("Error while deleting audio file: ", error)
            }
        }
    }
    
    func delete_playback(url: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent(url)
        
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
            } catch let error {
                print("Error while deleting audio file: ", error)
            }
        }
    }
    
    func delete_image(url: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent(url)
        
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
            } catch let error {
                print("Error while deleting audio file: ", error)
            }
        }
    }
    
    func task_exists(PlaybackID: String) async -> Bool {
        if await (self.downloadActor.tracksLookup[PlaybackID] != nil) {
            return true
        } else {
            return false
        }
    }
    
    func taskID_to_tracks_downloading(taskID: UUID?) -> DownloadData? {
        let firstTask: DownloadData? = self.tracksDownloading.first(where: { $0.id == taskID })
        return firstTask
    }
}

