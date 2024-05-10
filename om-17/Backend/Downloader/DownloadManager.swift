//
//  DownloadManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-10.
//

import SwiftUI

//@MainActor
@Observable class DownloadManager: DownloaderDelegate {
    static let shared = DownloadManager()
    let downloader: Downloader = Downloader()
    let max_downloads: Int = 8
    var currently_downloading: Int = 0
    var tracks_downloading: [DownloadData] = []
    //var tracks
    var tracks_lookup: [String:UUID] = [:] // playbackID: taskID
    var downloadsCount: Int
    
    init() {
        self.downloadsCount = UserDefaults.standard.integer(forKey: "downloadsCount")
        //self.max_downloads = self.downloadsCount
        self.downloader.delegate = self
    }
    
    func add_download_task(track: any Track, explicit: Bool) {
        let thisPlaybackID = explicit ? track.Playback_Explicit! : track.Playback_Clean!
        if (self.is_playback_downloaded(PlaybackID: thisPlaybackID) || tracks_lookup[thisPlaybackID] != nil) {
            return
        }
        let thisDownload = DownloadData(track: track, explicit: explicit)
        thisDownload.state = .waiting
        tracks_lookup[thisDownload.playbackID] = thisDownload.id
        tracks_downloading.append(thisDownload)
        self.try_next_download()
    }
    
    func begin_download(downloadData: DownloadData) {
        if (self.currently_downloading < self.max_downloads) {
            self.currently_downloading += 1
            downloadData.state = .fetching
            Task { [unowned self] in
                let download_url = await self.get_download_url(PlaybackID: downloadData.playbackID)
                if download_url != nil {
                    let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Audio-\(downloadData.playbackID).mp4")
                    DispatchQueue.main.async { [unowned self] in
                        let newtask = DownloadTask(dID: String(downloadData.playbackID), source: download_url!, destination: destination!)
                        downloadData.downloadTask = newtask
                        self.downloader.start(newtask)
                        self.try_next_download()
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        downloadData.state = .error
                        downloadData.errorReason = "Couldn't retrieve download link"
                        self.currently_downloading -= 1
                        self.try_next_download()
                    }
                }
            }
        }
    }
    
    func try_next_download() {
        print("in try_next_download")
        if (self.currently_downloading < self.max_downloads) {
            print("good inequality")
            let nextdl: DownloadData? = self.tracks_downloading.first(where: {$0.state == .waiting})
            if let nextdl = nextdl {
                print("good data, beginning download...")
                self.begin_download(downloadData: nextdl)
                print("trying next download again.")
                try_next_download()
            }
        }
    }
    
    func cancel_download(PlaybackID: String) {
        let task: DownloadTask? = find_task(PlaybackID: PlaybackID)
        if let task = task {
            self.downloader.cancel(task)
        }
    }
    
    func retry_download(download: DownloadData) {
        self.tracks_lookup.removeValue(forKey: download.playbackID)
        self.tracks_downloading.removeAll(where: {$0.id == download.id})
        self.add_download_task(track: download.parent, explicit: download.explicit)
    }
    
    func is_playback_downloaded(PlaybackID: String?) -> Bool {
        if PlaybackID == nil {
            return false
        }
        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Audio-\(PlaybackID!).mp4")
        if FileManager().fileExists(atPath: destination!.path) {
            if (tracks_lookup[PlaybackID!] == nil || taskID_to_tracks_downloading(taskID: self.tracks_lookup[PlaybackID!])?.state == .success) {
                return(true)
            }
        }
        return(false)
    }
    
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
    
    func filter_downloaded(_ tracks: [any Track]) -> [any Track] {
        var downloadedTracks: [any Track] = []
        for track in tracks {
            if self.is_downloaded(track) {
                downloadedTracks.append(track)
            }
        }
        return(downloadedTracks)
    }
    
    func filter_downloaded(_ tracks: [PlaylistItem]) -> [PlaylistItem] {
        var downloadedTracks: [PlaylistItem] = []
        for item in tracks {
            if self.is_downloaded(item.track) {
                downloadedTracks.append(item)
            }
        }
        return(downloadedTracks)
    }
    
    func is_downloaded(_ track: any Track, explicit: Bool? = nil) -> Bool {
        if explicit == nil {
            if track.Playback_Explicit != nil {
                return is_playback_downloaded(PlaybackID: track.Playback_Explicit)
            } else {
                return is_playback_downloaded(PlaybackID: track.Playback_Clean)
            }
        } else {
            if explicit == true {
                return is_playback_downloaded(PlaybackID: track.Playback_Explicit)
            } else {
                return is_playback_downloaded(PlaybackID: track.Playback_Clean)
            }
        }
    }
    func is_downloaded(_ queueItem: QueueItem, explicit: Bool? = nil) -> Bool {
        if explicit == nil {
            if queueItem.Track.Playback_Explicit != nil {
                return is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Explicit)
            } else {
                return is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Clean)
            }
        } else {
            if explicit == true {
                return is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Explicit)
            } else {
                return is_playback_downloaded(PlaybackID: queueItem.Track.Playback_Clean)
            }
        }
    }
    
    func are_playbacks_downloaded(PlaybackIDs: [String]) -> Bool {
        return PlaybackIDs.allSatisfy { playbackID in
            is_playback_downloaded(PlaybackID: playbackID)
        }
    }
    
    func sum_progression() -> Double {
        var sum: Double = 0
        for dl in self.tracks_downloading {
            sum += dl.progress
        }
        return (sum / Double(self.tracks_downloading.count))
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
    
    func get_error_reason(PlaybackID: String) -> String? {
        return self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[PlaybackID])?.errorReason
    }
    
    private func get_download_url(PlaybackID: String) async -> URL? {
        do {
            let fetchedData = try await fetchPlaybackData(PlaybackID: PlaybackID)
            if fetchedData.Playback_Audio_URL == "" {
                return nil
            }
            return (URL(string: fetchedData.Playback_Audio_URL)!)
        } catch {
            return nil
        }
    }
    
    func find_task(PlaybackID: String) -> DownloadTask? {
        return self.downloader.tasks.first(where: {$0.value.dID == String(PlaybackID)})?.value
    }
    
    func find_download_data(PlaybackID: String) -> DownloadData? {
        for track in self.tracks_downloading {
            if track.playbackID == PlaybackID {
                return track
            }
        }
        return nil
        //return self.tracks_downloading.first(where: { $0.playbackID == PlaybackID })
    }
    
    func task_exists(PlaybackID: String) -> Bool {
        if (self.tracks_lookup[PlaybackID] != nil) {
            return true
        } else {
            return false
        }
    }
    
    func taskID_to_tracks_downloading(taskID: UUID?) -> DownloadData? {
        let firstTask: DownloadData? = self.tracks_downloading.first(where: { $0.id == taskID })
        return firstTask
    }
    
    
    // DELEGATE FUNCTIONS
    func downloadStarted(downloader: Downloader, task: DownloadTask) {
        ds(downloader: downloader, task: task)
    }
    func ds(downloader: Downloader, task: DownloadTask) {
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.state = .downloading
    }
    func downloadCanceled(downloader: Downloader, task: DownloadTask) {
        dc(downloader: downloader, task: task)
    }
    func dc(downloader: Downloader, task: DownloadTask) {
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.state = .cancelled
        self.try_next_download()
    }
    func downloadFinished(downloader: Downloader, task: DownloadTask) {
        df(downloader: downloader, task: task)
    }
    func df(downloader: Downloader, task: DownloadTask) {
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.state = .success
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.location = task.destination
        self.currently_downloading -= 1
        do {
            self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.size = try FileManager.default.attributesOfItem(atPath: task.destination.path())[.size] as! Int
        } catch {
            self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.size = -1
        }
        self.try_next_download()
    }
    func downloadProgressChanged(downloader: Downloader, task: DownloadTask) {
        dpc(downloader: downloader, task: task)
    }
    func dpc(downloader: Downloader, task: DownloadTask) {
        DispatchQueue.main.async {
            self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.progress = task.progress // ISSUE HERE GETTING PROGRESS
        }
    }
    func downloadError(downloader: Downloader, task: DownloadTask, error: Error) {
        de(downloader: downloader, task: task, error: error)
    }
    func de(downloader: Downloader, task: DownloadTask, error: Error) {
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.state = .error
        self.taskID_to_tracks_downloading(taskID: self.tracks_lookup[task.dID])?.errorReason = error.localizedDescription
        self.currently_downloading -= 1
        self.try_next_download()
    }
    
}
